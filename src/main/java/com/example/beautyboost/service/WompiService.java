package com.example.beautyboost.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.*;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.time.LocalDate;
import java.util.*;

@Service
public class WompiService {
  private final JdbcTemplate jdbc; @Value("${wompi.integrity-secret:}") private String integritySecret; @Value("${wompi.events-secret:}") private String eventsSecret;
  public WompiService(JdbcTemplate jdbc){this.jdbc=jdbc;}
  public String nuevaReferencia(){return "BB-"+UUID.randomUUID().toString().replace("-","").substring(0,18).toUpperCase(Locale.ROOT);}
  public String firmaIntegridad(String ref,long cents,String currency){return sha256(ref+cents+currency+integritySecret);}
  public boolean checksumValido(String raw, String checksum){ return !eventsSecret.isBlank() && sha256(raw+eventsSecret).equalsIgnoreCase(checksum); }
  public static String sha256(String text){ try {byte[] hash=MessageDigest.getInstance("SHA-256").digest(text.getBytes(StandardCharsets.UTF_8));StringBuilder out=new StringBuilder();for(byte b:hash)out.append(String.format("%02x",b));return out.toString();}catch(Exception e){throw new IllegalStateException(e);} }
  @Transactional
  public String actualizarTransaccion(String referencia,String transactionId,String status,long amountInCents){
    List<Map<String,Object>> pedidos=jdbc.queryForList("SELECT id_pedido,total,estado_pedido FROM pedido WHERE wompi_reference=? FOR UPDATE",referencia); if(pedidos.isEmpty()) return null;
    Map<String,Object> p=pedidos.get(0); BigDecimal total=(BigDecimal)p.get("total"); if(total.movePointRight(2).longValue()!=amountInCents) throw new IllegalArgumentException("Monto Wompi no coincide con pedido");
    long pedido=((Number)p.get("id_pedido")).longValue(); String estado="APPROVED".equals(status)?"Pagado":Set.of("DECLINED","ERROR","VOIDED").contains(status)?"Rechazado":"Pendiente";
    jdbc.update("UPDATE pedido SET wompi_transaction_id=?,wompi_status=?,estado_pedido=? WHERE id_pedido=?",transactionId,status,estado,pedido);
    if("APPROVED".equals(status) && jdbc.queryForObject("SELECT COUNT(*) FROM pago WHERE pedido_id_pedido=?",Integer.class,pedido)==0){
      List<Map<String,Object>> detalles=jdbc.queryForList("SELECT producto_id_producto,cantidad FROM detalle_pedido WHERE pedido_id_pedido=?",pedido);
      for(Map<String,Object>d:detalles){int c=((Number)d.get("cantidad")).intValue();long producto=((Number)d.get("producto_id_producto")).longValue();if(jdbc.update("UPDATE producto SET stock=stock-? WHERE id_producto=? AND stock>=?",c,producto,c)!=1)throw new IllegalStateException("Stock insuficiente");}
      jdbc.update("INSERT INTO pago(fecha_pago,monto_pagado,metodo_de_pago_id_metodo_pago,pedido_id_pedido,wompi_transaction_id,wompi_status) VALUES(?,?,?,?,?,?)",LocalDate.now(),total,3,pedido,transactionId,status);
    } return estado;
  }
}
