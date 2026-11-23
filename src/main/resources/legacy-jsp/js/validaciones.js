(function(){
  "use strict";
  window.BBValidaciones={
    soloDigitos:function(v){return String(v||"").replace(/\D/g,"");},
    documento:function(v,min,max){var x=this.soloDigitos(v);return x.length>=(min||6)&&x.length<=(max||10);},
    telefono:function(v){var x=this.soloDigitos(v);return /^3\d{9}$/.test(x);},
    correo:function(v){return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(v||"").trim());},
    requerido:function(v){return String(v||"").trim().length>0;},
    limitarDigitos:function(el,min,max){if(!el)return;el.value=this.soloDigitos(el.value).slice(0,max);},
    conectarFormulario:function(form){
      if(!form)return;
      form.querySelectorAll('[data-validacion="documento"]').forEach(function(el){
        el.addEventListener('input',function(){window.BBValidaciones.limitarDigitos(el,6,10);});
        el.addEventListener('blur',function(){
          if(!el.value){el.setCustomValidity('El documento es obligatorio.');return;}
          el.setCustomValidity(window.BBValidaciones.documento(el.value,6,10)?"":"El documento debe contener entre 6 y 10 dígitos numéricos.");
        });
      });
      form.querySelectorAll('[data-validacion="telefono"]').forEach(function(el){
        el.addEventListener('input',function(){window.BBValidaciones.limitarDigitos(el,10,10);});
        el.addEventListener('blur',function(){
          if(!el.value){el.setCustomValidity('El teléfono es obligatorio.');return;}
          el.setCustomValidity(window.BBValidaciones.telefono(el.value)?"":"El celular debe tener 10 dígitos y comenzar por 3.");
        });
      });
      form.addEventListener('submit',function(){
        form.querySelectorAll('[data-validacion="documento"],[data-validacion="telefono"]').forEach(function(el){el.dispatchEvent(new Event('blur'));});
      });
      form.querySelectorAll('[type="email"]').forEach(function(el){el.addEventListener('blur',function(){el.setCustomValidity(window.BBValidaciones.correo(el.value)?"":"Ingresa un correo válido.");});});
    }
  };
  document.addEventListener('DOMContentLoaded',function(){
    document.querySelectorAll('input,select,textarea').forEach(function(el){
      var key=((el.name||'')+' '+(el.id||'')).toLowerCase();
      if(!el.dataset.validacion && /(documento|identificacion|cedula|legalid)/.test(key)) el.dataset.validacion='documento';
      else if(!el.dataset.validacion && /(telefono|celular|phone)/.test(key)) el.dataset.validacion='telefono';
    });
    document.querySelectorAll('form').forEach(window.BBValidaciones.conectarFormulario);
    document.querySelectorAll('input[data-validacion="documento"]').forEach(function(el){el.inputMode='numeric';el.maxLength=10;});
    document.querySelectorAll('input[data-validacion="telefono"]').forEach(function(el){el.inputMode='numeric';el.maxLength=10;});
  });
})();
