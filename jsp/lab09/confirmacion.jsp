<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    if (session.getAttribute("reserva") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<c:set var="titulo" value="Reserva confirmada" />
<c:set var="r" value="${sessionScope.reserva}" />
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

  <main class="contenedor">
    <section class="encabezado">
      <h1 class="titulo-grande">Reserva confirmada</h1>
      <p class="lead">Gracias, <c:out value="${r.nombre}" />. Presenta este código al llegar a Mesa Mantaro.</p>
    </section>

    <section class="mosaico">
      <article class="tarjeta tarjeta-naranja col-5">
        <i data-lucide="calendar-check" class="icono-grande"></i>
        <p class="codigo"><c:out value="${r.codigo}" /></p>
        <p>Código de reserva. Reservas en esta sesión: <c:out value="${sessionScope.totalReservas}" />.</p>
      </article>

      <article class="tarjeta tarjeta-gris col-7">
        <h2 class="tarjeta-titulo">Resumen</h2>
        <dl class="detalle">
          <div class="detalle-fila"><dt>Nombre</dt><dd><c:out value="${r.nombre}" /></dd></div>
          <div class="detalle-fila"><dt>Correo</dt><dd><c:out value="${r.correo}" /></dd></div>
          <div class="detalle-fila"><dt>Teléfono</dt><dd><c:out value="${r.telefono}" /></dd></div>
          <div class="detalle-fila"><dt>Personas</dt><dd><c:out value="${r.personas}" /></dd></div>
          <div class="detalle-fila"><dt>Fecha</dt><dd><c:out value="${r.fecha}" /></dd></div>
          <div class="detalle-fila"><dt>Hora</dt><dd><c:out value="${r.hora}" /></dd></div>
          <div class="detalle-fila"><dt>Zona</dt><dd><c:out value="${r.zona}" /></dd></div>
          <div class="detalle-fila"><dt>Ocasión</dt><dd><c:out value="${r.ocasion}" /></dd></div>
          <div class="detalle-fila"><dt>Notas</dt><dd><c:out value="${r.notas}" /></dd></div>
        </dl>
      </article>

      <article class="tarjeta tarjeta-imagen col-12">
        <img src="https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=1600&q=80" alt="lorem ipsum" loading="lazy">
        <div class="tarjeta-contenido">
          <h2 class="tarjeta-titulo">Te esperamos</h2>
          <p>Av. Real 123, Huancayo. Tu mesa se mantiene 15 minutos después de la hora reservada.</p>
        </div>
      </article>

      <article class="tarjeta tarjeta-azul tarjeta-compacta col-12">
        <div>
          <h2 class="tarjeta-titulo">¿Otra reserva?</h2>
          <p>Tus datos de contacto siguen guardados en esta sesión.</p>
        </div>
        <div>
          <a class="boton boton-claro" href="index.jsp#reservar"><i data-lucide="calendar"></i>Nueva reserva</a>
        </div>
      </article>
    </section>
  </main>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>