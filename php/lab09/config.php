<?php

declare(strict_types=1);

ini_set('display_errors', '0');
ini_set('log_errors', '1');

date_default_timezone_set('America/Lima');

const RESTAURANTE_NOMBRE = 'Mesa Mantaro';
const RESERVA_MAX_PERSONAS = 12;
const RESERVA_MAX_DIAS = 60;

const RESERVA_HORAS = [
    '12:00', '12:30', '13:00', '13:30', '14:00', '14:30', '15:00', '15:30',
    '16:00', '16:30', '17:00', '17:30', '18:00', '18:30', '19:00', '19:30',
    '20:00', '20:30', '21:00', '21:30',
];

const RESERVA_ZONAS = [
    'salon' => 'Salón principal',
    'terraza' => 'Terraza',
    'barra' => 'Barra',
    'privada' => 'Sala privada',
];

const RESERVA_OCASIONES = [
    'ninguna' => 'Ninguna',
    'cumpleanos' => 'Cumpleaños',
    'aniversario' => 'Aniversario',
    'familiar' => 'Reunión familiar',
    'negocios' => 'Reunión de negocios',
];

function escapar(string $valor): string
{
    return htmlspecialchars($valor, ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8');
}

function generar_codigo(): string
{
    return 'MM-' . strtoupper(bin2hex(random_bytes(3)));
}

function formatear_fecha(DateTimeImmutable $fecha): string
{
    $dias = ['domingo', 'lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado'];
    $meses = [
        1 => 'enero', 2 => 'febrero', 3 => 'marzo', 4 => 'abril',
        5 => 'mayo', 6 => 'junio', 7 => 'julio', 8 => 'agosto',
        9 => 'setiembre', 10 => 'octubre', 11 => 'noviembre', 12 => 'diciembre',
    ];

    return $dias[(int) $fecha->format('w')]
        . ' ' . $fecha->format('j')
        . ' de ' . $meses[(int) $fecha->format('n')]
        . ' de ' . $fecha->format('Y');
}