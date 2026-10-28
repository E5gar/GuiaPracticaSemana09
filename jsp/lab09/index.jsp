<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/WEB-INF/jspf/config.jspf" %>
<c:set var="titulo" value="Reserva tu mesa" />
<%@ include file="/WEB-INF/jspf/cabecera.jspf" %>

  <main class="contenedor">
    <section class="encabezado">
      <h1 class="titulo-grande">Reserva tu mesa</h1>
      <p class="lead">Cocina andina de temporada en el corazón del valle del Mantaro. Completa el formulario y recibe tu código de reserva al instante.</p>
      <c:if test="${not empty sessionScope.reserva}">
        <p class="lead">
          <a class="pildora" href="confirmacion.jsp">
            <i data-lucide="calendar-check"></i>Tu última reserva: <c:out value="${sessionScope.reserva.codigo}" />
          </a>
        </p>
      </c:if>
    </section>

    <section class="mosaico">
      <article class="tarjeta tarjeta-gris col-7" id="reservar">
        <h2 class="tarjeta-titulo">Datos de la reserva</h2>

        <form class="formulario" action="procesar.jsp" method="post">
          <div class="campo campo-completo">
            <label for="nombre"><i data-lucide="user"></i>Nombre completo</label>
            <input class="entrada" type="text" id="nombre" name="nombre" required minlength="3" maxlength="80" autocomplete="name" placeholder="Nombres y apellidos" value="<c:out value='${sessionScope.reserva.nombre}' />">
          </div>

          <div class="campo">
            <label for="correo"><i data-lucide="mail"></i>Correo electrónico</label>
            <input class="entrada" type="email" id="correo" name="correo" required maxlength="120" autocomplete="email" placeholder="nombre@correo.com" value="<c:out value='${sessionScope.reserva.correo}' />">
          </div>

          <div class="campo">
            <label for="telefono"><i data-lucide="phone"></i>Teléfono</label>
            <input class="entrada" type="tel" id="telefono" name="telefono" required pattern="\+?[0-9 ]{9,15}" autocomplete="tel" placeholder="964 000 000" value="<c:out value='${sessionScope.reserva.telefono}' />">
          </div>

          <div class="campo">
            <label for="fecha"><i data-lucide="calendar"></i>Fecha</label>
            <input class="entrada" type="date" id="fecha" name="fecha" required min="${fechaMin}" max="${fechaMax}">
          </div>

          <div class="campo">
            <label for="hora"><i data-lucide="clock"></i>Hora</label>
            <select class="entrada" id="hora" name="hora" required>
              <option value="" selected disabled>Elige una hora</option>
              <c:forEach var="h" items="${horas}">
                <option value="${h}">${h}</option>
              </c:forEach>
            </select>
          </div>

          <div class="campo">
            <label for="personas"><i data-lucide="users"></i>Personas</label>
            <input class="entrada" type="number" id="personas" name="personas" required min="1" max="${maxPersonas}" value="2">
          </div>

          <div class="campo">
            <label for="zona"><i data-lucide="armchair"></i>Zona</label>
            <select class="entrada" id="zona" name="zona" required>
              <c:forEach var="z" items="${zonas}">
                <option value="${z.key}" ${z.key == 'salon' ? 'selected' : ''}>${z.value}</option>
              </c:forEach>
            </select>
          </div>

          <div class="campo campo-completo">
            <label for="ocasion"><i data-lucide="party-popper"></i>Ocasión</label>
            <select class="entrada" id="ocasion" name="ocasion">
              <c:forEach var="o" items="${ocasiones}">
                <option value="${o.key}" ${o.key == 'ninguna' ? 'selected' : ''}>${o.value}</option>
              </c:forEach>
            </select>
          </div>

          <div class="campo campo-completo">
            <label for="notas"><i data-lucide="message-square"></i>Notas para el restaurante</label>
            <textarea class="entrada" id="notas" name="notas" maxlength="200" placeholder="Alergias, silla para bebé, decoración..."></textarea>
          </div>

          <div class="campo campo-completo">
            <button class="boton" type="submit"><i data-lucide="calendar-check"></i>Confirmar reserva</button>
          </div>
        </form>
      </article>

      <div class="columna-lateral col-5">
        <article class="tarjeta tarjeta-imagen" id="menu">
          <img src="https://images.unsplash.com/photo-1414235077428-338989a2e8c0?auto=format&fit=crop&w=1000&q=80" alt="lorem ipsum" loading="lazy">
          <div class="tarjeta-contenido">
            <h2 class="tarjeta-titulo">Cocina andina de temporada</h2>
            <p>Trucha, cuy confitado y papa nativa del valle del Mantaro.</p>
          </div>
        </article>

        <article class="tarjeta tarjeta-naranja tarjeta-compacta" id="horarios">
          <i data-lucide="clock" class="icono-grande"></i>
          <div>
            <h2 class="tarjeta-titulo">Horarios</h2>
            <p>Todos los días de 12:00 a 22:00. Última reserva a las 21:30.</p>
          </div>
        </article>

        <article class="tarjeta tarjeta-azul tarjeta-compacta">
          <i data-lucide="users" class="icono-grande"></i>
          <div>
            <h2 class="tarjeta-titulo">Grupos</h2>
            <p>Hasta ${maxPersonas} personas por reserva. Para más, llámanos.</p>
          </div>
        </article>

        <article class="tarjeta tarjeta-negra tarjeta-compacta">
          <div class="titulo-con-icono">
            <h2 class="tarjeta-titulo">Tus datos</h2>
            <i data-lucide="lock" class="icono-grande"></i>
          </div>
          <p>Recordamos tu nombre y contacto solo durante tu sesión de 15 minutos.</p>
        </article>
      </div>
    </section>
  </main>

<%@ include file="/WEB-INF/jspf/pie.jspf" %>