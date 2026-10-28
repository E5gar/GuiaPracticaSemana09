<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ page import="java.time.LocalTime, java.time.format.DateTimeParseException" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/WEB-INF/jspf/config.jspf" %>
<%
    String estado = "metodo";
    Map<String, String> errores = new LinkedHashMap<>();

    if (!"POST".equals(request.getMethod())) {
        response.setStatus(405);
        response.setHeader("Allow", "POST");
    } else {
        String nombre = limpiar(request.getParameter("nombre"));
        String correo = limpiar(request.getParameter("correo"));
        String telefono = limpiar(request.getParameter("telefono"));
        String personasTxt = limpiar(request.getParameter("personas"));
        String fechaTxt = limpiar(request.getParameter("fecha"));
        String hora = limpiar(request.getParameter("hora"));
        String zona = limpiar(request.getParameter("zona"));
        String ocasion = limpiar(request.getParameter("ocasion"));
        String notas = limpiar(request.getParameter("notas"));

        if (ocasion.isEmpty()) {
            ocasion = "ninguna";
        }

        if (nombre.length() < 3 || nombre.length() > 80 || !PATRON_NOMBRE.matcher(nombre).matches()) {
            errores.put("nombre", "Escribe tu nombre completo, solo con letras, entre 3 y 80 caracteres.");
        }

        if (correo.length() > 120 || !PATRON_CORREO.matcher(correo).matches()) {
            errores.put("correo", "Escribe un correo electrónico válido, por ejemplo nombre@correo.com.");
        }

        if (!PATRON_TELEFONO.matcher(telefono).matches()) {
            errores.put("telefono", "Escribe un teléfono de 9 a 15 dígitos, con prefijo opcional.");
        }

        int personas = 0;
        try {
            personas = Integer.parseInt(personasTxt);
        } catch (NumberFormatException e) {
            personas = 0;
        }
        if (personas < 1 || personas > MAX_PERSONAS) {
            errores.put("personas", "El número de personas debe estar entre 1 y " + MAX_PERSONAS + ".");
        }

        LocalDate hoy = LocalDate.now(ZONA_HORARIA);
        LocalDate fecha = null;
        try {
            fecha = LocalDate.parse(fechaTxt);
        } catch (DateTimeParseException e) {
            fecha = null;
        }
        if (fecha == null) {
            errores.put("fecha", "Elige una fecha válida.");
        } else if (fecha.isBefore(hoy) || fecha.isAfter(hoy.plusDays(MAX_DIAS))) {
            errores.put("fecha", "La fecha debe estar entre hoy y los próximos " + MAX_DIAS + " días.");
        }

        if (!HORAS.contains(hora)) {
            errores.put("hora", "Elige una hora de la lista, entre 12:00 y 21:30.");
        } else if (fecha != null && fecha.equals(hoy) && !LocalTime.parse(hora).isAfter(LocalTime.now(ZONA_HORARIA))) {
            errores.put("hora", "Esa hora ya pasó. Elige una hora posterior.");
        }

        if (!ZONAS.containsKey(zona)) {
            errores.put("zona", "Elige una zona de la lista.");
        }

        if (!OCASIONES.containsKey(ocasion)) {
            errores.put("ocasion", "Elige una ocasión de la lista.");
        }

        if (notas.length() > 200) {
            errores.put("notas", "Las notas no pueden superar los 200 caracteres.");
        }

        if (errores.isEmpty()) {
            Map<String, String> reserva = new LinkedHashMap<>();
            reserva.put("codigo", generarCodigo());
            reserva.put("nombre", nombre);
            reserva.put("correo", correo);
            reserva.put("telefono", telefono);
            reserva.put("personas", String.valueOf(personas));
            reserva.put("fecha", formatearFecha(fecha));
            reserva.put("hora", hora);
            reserva.put("zona", ZONAS.get(zona));
            reserva.put("ocasion", OCASIONES.get(ocasion));
            reserva.put("notas", notas.isEmpty() ? "Sin notas" : notas);

            Integer total = (Integer) session.getAttribute("totalReservas");
            session.setAttribute("reserva", Collections.unmodifiableMap(reserva));
            session.setAttribute("totalReservas", total == null ? 1 : total + 1);

            response.sendRedirect("confirmacion.jsp");
            return;
        }

        response.setStatus(422);
        estado = "error";
    }

    pageContext.setAttribute("estado", estado);
    pageContext.setAttribute("errores", errores.values());
%>
<c:set var="titulo" value="${estado == 'error' ? 'Revisa los datos' : 'Método no permitido'}" />
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

  <main class="contenedor">
    <section class="encabezado">
      <h1 class="titulo-grande"><c:out value="${titulo}" /></h1>
      <c:choose>
        <c:when test="${estado == 'error'}">
          <p class="lead">No pudimos registrar tu reserva. Corrige lo siguiente y vuelve a enviarla.</p>
        </c:when>
        <c:otherwise>
          <p class="lead">Esta página solo recibe reservas enviadas desde el formulario con el método POST.</p>
        </c:otherwise>
      </c:choose>
    </section>

    <section class="mosaico">
      <c:choose>
        <c:when test="${estado == 'error'}">
          <article class="tarjeta tarjeta-negra tarjeta-compacta col-12">
            <div>
              <h2 class="tarjeta-titulo">Datos por corregir</h2>
              <ul class="lista-errores">
                <c:forEach var="mensaje" items="${errores}">
                  <li><i data-lucide="circle-alert"></i><span><c:out value="${mensaje}" /></span></li>
                </c:forEach>
              </ul>
            </div>
            <div>
              <a class="boton boton-claro" href="index.jsp#reservar"><i data-lucide="arrow-left"></i>Volver al formulario</a>
            </div>
          </article>
        </c:when>
        <c:otherwise>
          <article class="tarjeta tarjeta-negra tarjeta-compacta col-12">
            <div>
              <h2 class="tarjeta-titulo">Solo se acepta POST</h2>
              <p>Abre el formulario, completa tus datos y envíalo desde ahí.</p>
            </div>
            <div>
              <a class="boton boton-claro" href="index.jsp#reservar"><i data-lucide="arrow-left"></i>Ir al formulario</a>
            </div>
          </article>
        </c:otherwise>
      </c:choose>
    </section>
  </main>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>