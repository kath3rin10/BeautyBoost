(function(){
  'use strict';
  function esc(v){return String(v).replace(/[&<>"']/g,function(c){return {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c];});}
  function money(v){return '$'+Number(v||0).toLocaleString('es-CO',{maximumFractionDigits:0});}
  function compactMoney(v){
    var n=Number(v||0);
    if(n>=1000000)return '$'+(n/1000000).toFixed(n>=10000000?0:1)+' M';
    if(n>=1000)return '$'+Math.round(n/1000)+' mil';
    return money(n);
  }
  var labels=['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'];

  function summaryMarkup(items){
    return '<div class="analytics-summary">'+items.map(function(item){
      return '<div class="analytics-summary-item"><span>'+esc(item.label)+'</span><strong>'+esc(item.value)+'</strong></div>';
    }).join('')+'</div>';
  }

  function renderSales(values){
    var el=document.getElementById('salesChart'); if(!el)return;
    values=(Array.isArray(values)?values:[]).map(function(v){return Number(v)||0;});
    while(values.length<12)values.push(0);
    var total=values.reduce(function(a,b){return a+b;},0);
    var active=values.filter(function(v){return v>0;});
    var avg=active.length?total/active.length:0;
    var max=Math.max.apply(null,values.concat([0]));
    var best=max>0?values.indexOf(max):-1;
    if(total<=0){
      el.innerHTML='<div class="analytics-empty-state"><div class="analytics-empty-icon"><i class="fas fa-chart-line"></i></div><strong>Aún no hay ventas registradas</strong><span>Cuando se complete una compra aparecerá aquí la evolución mensual de los ingresos.</span></div>';
      return;
    }
    var w=960,h=290,padL=44,padR=18,padT=25,padB=42;
    var innerW=w-padL-padR, innerH=h-padT-padB;
    var yMax=Math.max(max,1);
    var points=values.map(function(v,i){
      var x=padL+(innerW*(i/11));
      var y=padT+innerH-(v/yMax*innerH);
      return {x:x,y:y,v:v};
    });
    var path=points.map(function(p,i){return (i?'L':'M')+p.x.toFixed(1)+' '+p.y.toFixed(1);}).join(' ');
    var area='M'+points[0].x.toFixed(1)+' '+(padT+innerH).toFixed(1)+' '+points.map(function(p){return 'L'+p.x.toFixed(1)+' '+p.y.toFixed(1);}).join(' ')+' L'+points[points.length-1].x.toFixed(1)+' '+(padT+innerH).toFixed(1)+' Z';
    var grid=[0,.25,.5,.75,1].map(function(r){
      var y=padT+innerH-(r*innerH);
      var val=yMax*r;
      return '<line x1="'+padL+'" y1="'+y.toFixed(1)+'" x2="'+(w-padR)+'" y2="'+y.toFixed(1)+'" class="analytics-grid-line"/><text x="8" y="'+(y+4).toFixed(1)+'" class="analytics-axis-label">'+esc(compactMoney(val))+'</text>';
    }).join('');
    var xlabels=labels.map(function(label,i){return '<text x="'+points[i].x.toFixed(1)+'" y="'+(h-13)+'" text-anchor="middle" class="analytics-axis-label analytics-axis-month">'+label+'</text>';}).join('');
    var dots=points.map(function(p,i){
      var title=labels[i]+': '+money(p.v);
      return '<g class="analytics-point"><circle cx="'+p.x.toFixed(1)+'" cy="'+p.y.toFixed(1)+'" r="4.5"></circle><title>'+esc(title)+'</title></g>';
    }).join('');
    el.innerHTML=summaryMarkup([
      {label:'Ingresos del año',value:money(total)},
      {label:'Promedio mensual',value:money(avg)},
      {label:'Mes más alto',value:best>=0?labels[best]+' · '+money(max):'—'}
    ])+'<div class="analytics-chart-shell"><svg class="analytics-line-svg" viewBox="0 0 '+w+' '+h+'" role="img" aria-label="Evolución mensual de ventas">'+grid+'<path d="'+area+'" class="analytics-area"></path><path d="'+path+'" class="analytics-line"></path>'+dots+xlabels+'</svg></div>';
  }

  function renderOrders(values){
    var el=document.getElementById('ordersChart'); if(!el)return;
    values=(Array.isArray(values)?values:[]).map(function(v){return Math.max(0,Number(v)||0);});
    while(values.length<12)values.push(0);
    var total=values.reduce(function(a,b){return a+b;},0);
    var active=values.filter(function(v){return v>0;});
    var avg=active.length?total/active.length:0;
    var max=Math.max.apply(null,values.concat([0]));
    var best=max>0?values.indexOf(max):-1;
    if(total<=0){
      el.innerHTML='<div class="analytics-empty-state"><div class="analytics-empty-icon"><i class="fas fa-bag-shopping"></i></div><strong>Aún no hay pedidos</strong><span>Los pedidos aparecerán aquí automáticamente cuando un cliente complete una compra.</span></div>';
      return;
    }
    var bars=labels.map(function(label,i){
      var value=values[i],pct=max?Math.max(0,Math.round(value/max*100)):0;
      return '<div class="orders-row"><div class="orders-month">'+label+'</div><div class="orders-track"><span style="width:'+pct+'%"></span></div><strong class="orders-value">'+value+'</strong></div>';
    }).join('');
    el.innerHTML=summaryMarkup([
      {label:'Pedidos registrados',value:String(total)},
      {label:'Promedio mensual',value:avg.toFixed(1).replace('.',',')},
      {label:'Mes con más pedidos',value:best>=0?labels[best]+' · '+max:'—'}
    ])+'<div class="orders-rows">'+bars+'</div>';
  }

  function renderInventory(){
    var el=document.getElementById('inventoryChart'); if(!el)return;
    var data=Array.isArray(window.BB_ADMIN&&window.BB_ADMIN.inventory)?window.BB_ADMIN.inventory.map(Number):[0,0,0];
    var labels=['Stock saludable','Stock bajo','Agotados'];
    var total=data.reduce(function(a,b){return a+(Number(b)||0);},0);
    el.innerHTML='<div class="dashboard-inventory-summary">'
      +'<div class="inventory-total"><strong>'+total+'</strong><span>productos</span></div>'
      +labels.map(function(label,i){return '<div class="inventory-state"><span class="inventory-dot dot-'+i+'"></span><div><strong>'+data[i]+'</strong><small>'+label+'</small></div></div>';}).join('')
      +'</div>';
  }
  function init(){
    var data=window.BB_ADMIN||{};
    renderSales(data.sales);
    renderOrders(data.orders);
    renderInventory();
  }
  if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',init);else init();
})();
