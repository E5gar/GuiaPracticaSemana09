<?php

declare(strict_types=1);

require_once __DIR__ . '/config.php';

header('Content-Type: text/html; charset=UTF-8');
header('X-Content-Type-Options: nosniff');
header('X-Frame-Options: DENY');
header('Referrer-Policy: same-origin');

$estado = 'exito';
$errores = [];
$detalle = [];
$codigo = '';
$primerNombre = '';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    header('Allow: POST');
    $estado = 'metodo';
} else {
    $nombre = trim((string) filter_input(INPUT_POST, 'nombre', FILTER_UNSAFE_RAW));
    $correo = filter_input(INPUT_POST, 'correo', FILTER_VALIDATE_EMAIL);
    $telefono = filter_input(
        INPUT_POST,
        'telefono',
        FILTER_VALIDATE_REGEXP,
        ['options' => ['regexp' => '/^\+?[0-9 ]{9,15}$/']]
    );
    $personas = filter_input(
        INPUT_POST,
        'personas',
        FILTER_VALIDATE_INT,
        ['options' => ['min_range' => 1, 'max_range' => RESERVA_MAX_PERSONAS]]
    );
    $fechaTexto = trim((string) filter_input(INPUT_POST, 'fecha', FILTER_UNSAFE_RAW));
    $hora = trim((string) filter_input(INPUT_POST, 'hora', FILTER_UNSAFE_RAW));
    $zona = trim((string) filter_input(INPUT_POST, 'zona', FILTER_UNSAFE_RAW));
    $ocasion = trim((string) filter_input(INPUT_POST, 'ocasion', FILTER_UNSAFE_RAW));
    $notas = trim((string) filter_input(INPUT_POST, 'notas', FILTER_UNSAFE_RAW));

    if ($ocasion === '') {
        $ocasion = 'ninguna';
    }

    $largoNombre = mb_strlen($nombre);
    if ($largoNombre < 3 || $largoNombre > 80 || !preg_match("/^[\p{L}][\p{L} .'-]*$/u", $nombre)) {
        $errores['nombre'] = 'Escribe tu nombre completo, solo con letras, entre 3 y 80 caracteres.';
    }

    if ($correo === false || $correo === null) {
        $errores['correo'] = 'Escribe un correo electrónico válido, por ejemplo nombre@correo.com.';
    }

    if ($telefono === false || $telefono === null) {
        $errores['telefono'] = 'Escribe un teléfono de 9 a 15 dígitos, con prefijo opcional.';
    }

    if ($personas === false || $personas === null) {
        $errores['personas'] = 'El número de personas debe estar entre 1 y ' . RESERVA_MAX_PERSONAS . '.';
    }

    $fecha = DateTimeImmutable::createFromFormat('!Y-m-d', $fechaTexto);
    $hoy = new DateTimeImmutable('today');
    $limite = $hoy->modify('+' . RESERVA_MAX_DIAS . ' days');

    if ($fecha === false || $fecha->format('Y-m-d') !== $fechaTexto) {
        $errores['fecha'] = 'Elige una fecha válida.';
    } elseif ($fecha < $hoy || $fecha > $limite) {
        $errores['fecha'] = 'La fecha debe estar entre hoy y los próximos ' . RESERVA_MAX_DIAS . ' días.';
    }

    if (!in_array($hora, RESERVA_HORAS, true)) {
        $errores['hora'] = 'Elige una hora de la lista, entre 12:00 y 21:30.';
    } elseif (!isset($errores['fecha']) && $fecha == $hoy && new DateTimeImmutable($hora) <= new DateTimeImmutable('now')) {
        $errores['hora'] = 'Esa hora ya pasó. Elige una hora posterior.';
    }

    if (!array_key_exists($zona, RESERVA_ZONAS)) {
        $errores['zona'] = 'Elige una zona de la lista.';
    }

    if (!array_key_exists($ocasion, RESERVA_OCASIONES)) {
        $errores['ocasion'] = 'Elige una ocasión de la lista.';
    }

    if (mb_strlen($notas) > 200) {
        $errores['notas'] = 'Las notas no pueden superar los 200 caracteres.';
    }

    if ($errores !== []) {
        http_response_code(422);
        $estado = 'error';
    } else {
        $codigo = generar_codigo();
        $primerNombre = explode(' ', $nombre)[0];
        $detalle = [
            'Nombre' => $nombre,
            'Correo' => $correo,
            'Teléfono' => $telefono,
            'Personas' => (string) $personas,
            'Fecha' => formatear_fecha($fecha),
            'Hora' => $hora,
            'Zona' => RESERVA_ZONAS[$zona],
            'Ocasión' => RESERVA_OCASIONES[$ocasion],
            'Notas' => $notas !== '' ? $notas : 'Sin notas',
        ];
    }
}

$titulos = [
    'exito' => 'Reserva confirmada',
    'error' => 'Revisa los datos',
    'metodo' => 'Método no permitido',
];
$titulo = $titulos[$estado];
?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title><?= escapar($titulo) ?> | <?= escapar(RESTAURANTE_NOMBRE) ?></title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter+Tight:wght@400;500;600&family=Instrument+Serif&display=swap">
  <link rel="stylesheet" href="estilos.css">
</head>
<body>
  <header class="barra">
    <a class="logo" href="index.html" aria-label="Mesa Mantaro, inicio">M/m</a>
    <nav class="navegacion" aria-label="Principal">
      <a class="pildora" href="index.html#menu">Menú</a>
      <a class="pildora" href="index.html#reservar">Reservar</a>
      <a class="pildora" href="index.html#horarios">Horarios</a>
      <a class="pildora" href="index.html#contacto">Contacto</a>
    </nav>
    <div class="acciones">
      <a class="pildora" href="tel:+51964000000"><i data-lucide="phone"></i>Llamar</a>
      <a class="pildora pildora-naranja" href="index.html#reservar">Reservar</a>
    </div>
  </header>

  <main class="contenedor">
    <section class="encabezado">
      <h1 class="titulo-grande"><?= escapar($titulo) ?></h1>
      <?php if ($estado === 'exito'): ?>
        <p class="lead">Gracias, <?= escapar($primerNombre) ?>. Presenta este código al llegar a <?= escapar(RESTAURANTE_NOMBRE) ?>.</p>
      <?php elseif ($estado === 'error'): ?>
        <p class="lead">No pudimos registrar tu reserva. Corrige lo siguiente y vuelve a enviarla.</p>
      <?php else: ?>
        <p class="lead">Esta página solo recibe reservas enviadas desde el formulario con el método POST.</p>
      <?php endif; ?>
    </section>

    <section class="mosaico">
      <?php if ($estado === 'exito'): ?>
        <article class="tarjeta tarjeta-naranja col-5">
          <i data-lucide="calendar-check" class="icono-grande"></i>
          <p class="codigo"><?= escapar($codigo) ?></p>
          <p>Código de reserva</p>
        </article>

        <article class="tarjeta tarjeta-gris col-7">
          <h2 class="tarjeta-titulo">Resumen</h2>
          <dl class="detalle">
            <?php foreach ($detalle as $etiqueta => $valor): ?>
              <div class="detalle-fila">
                <dt><?= escapar((string) $etiqueta) ?></dt>
                <dd><?= escapar((string) $valor) ?></dd>
              </div>
            <?php endforeach; ?>
          </dl>
        </article>

        <article class="tarjeta tarjeta-imagen col-12">
          <img src="https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=1600&q=80" alt="lorem ipsum" loading="lazy">
          <div class="tarjeta-contenido">
            <h2 class="tarjeta-titulo">Te esperamos</h2>
            <p>Av. Real 123, Huancayo. Tu mesa se mantiene 15 minutos después de la hora reservada.</p>
          </div>
        </article>
      <?php elseif ($estado === 'error'): ?>
        <article class="tarjeta tarjeta-negra col-12">
          <h2 class="tarjeta-titulo">Datos por corregir</h2>
          <ul class="lista-errores">
            <?php foreach ($errores as $mensaje): ?>
              <li><i data-lucide="circle-alert"></i><span><?= escapar($mensaje) ?></span></li>
            <?php endforeach; ?>
          </ul>
          <a class="boton boton-claro" href="index.html#reservar"><i data-lucide="arrow-left"></i>Volver al formulario</a>
        </article>
      <?php else: ?>
        <article class="tarjeta tarjeta-negra col-12">
          <h2 class="tarjeta-titulo">Solo se acepta POST</h2>
          <p>Abre el formulario, completa tus datos y envíalo desde ahí.</p>
          <p style="margin-top: 24px;"><a class="boton boton-claro" href="index.html#reservar"><i data-lucide="arrow-left"></i>Ir al formulario</a></p>
        </article>
      <?php endif; ?>
    </section>
  </main>

  <footer class="contenedor pie">
    <span class="pildora"><i data-lucide="map-pin"></i>Av. Real 123, Huancayo</span>
    <a class="pildora" href="tel:+51964000000"><i data-lucide="phone"></i>964 000 000</a>
    <a class="pildora" href="mailto:reservas@mesamantaro.pe"><i data-lucide="mail"></i>reservas@mesamantaro.pe</a>
  </footer>

  <script src="https://unpkg.com/lucide@0.469.0/dist/umd/lucide.min.js"></script>
  <script>
    lucide.createIcons();
  </script>
</body>
</html>