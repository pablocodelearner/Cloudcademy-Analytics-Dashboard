use cloudcademy;

-- 1. Total de usuarios activos y suscriptores actuales.

SELECT 
    COUNT(*) AS num_active_users
FROM
    subscriptions
WHERE
    status = 'active';

-- 2. Ingresos totales y promedio por suscriptor.

WITH revenue_per_user AS (
	SELECT user_id, ROUND(SUM(amount), 2) as amount
	FROM payments
	group by 1
)
SELECT 
	(SELECT ROUND(SUM(amount), 2) FROM payments) AS 'Total Revenue', 
    (SELECT ROUND(AVG(amount), 2) FROM revenue_per_user) AS 'Average Revenue Per User (ARPU)';

-- 3. Número total de inscripciones por curso.

SELECT 
    course_title as 'Course', COUNT(*) AS 'Total enrollments'
FROM
    enrollments
        JOIN
    courses ON enrollments.course_id = courses.course_id
GROUP BY 1
ORDER BY 2 DESC;

-- 4. Proporción de finalización de cursos (por curso y categoría).

-- Por curso
SELECT 
    c.course_title,
    COUNT(e.enrollment_id) AS total_enrollments,
    SUM(CASE WHEN e.completion_status = 'completed' THEN 1 ELSE 0 END) AS completed_enrollments,
    (SUM(CASE WHEN e.completion_status = 'completed' THEN 1 ELSE 0 END) * 1.0 / COUNT(e.enrollment_id)) AS completion_rate
FROM 
    enrollments e
JOIN 
    courses c ON e.course_id = c.course_id
GROUP BY 
    c.course_title;

-- Por categoria
SELECT 
    c.category,
    COUNT(e.enrollment_id) AS total_enrollments,
    SUM(CASE WHEN e.completion_status = 'completed' THEN 1 ELSE 0 END) AS completed_enrollments,
    (SUM(CASE WHEN e.completion_status = 'completed' THEN 1 ELSE 0 END) * 1.0 / COUNT(e.enrollment_id)) AS completion_rate
FROM 
    enrollments e
JOIN 
    courses c ON e.course_id = c.course_id
GROUP BY 
    c.category;

-- 5. Tasa de churn de suscriptores (mensual y anual).

-- Churn rate mensual
WITH active_start_month AS (
    -- Calculamos el número de suscripciones activas al inicio del mes
    SELECT 
        DATE_FORMAT(start_date, '%Y-%m') AS month,
        COUNT(user_id) AS active_at_start
    FROM subscriptions
    WHERE status = 'active'
    GROUP BY DATE_FORMAT(start_date, '%Y-%m')
),
canceled_end_month AS (
    -- Calculamos el número de suscripciones canceladas en cada mes
    SELECT 
        DATE_FORMAT(end_date, '%Y-%m') AS month,
        COUNT(user_id) AS canceled_in_month
    FROM subscriptions
    WHERE status = 'canceled'
    GROUP BY DATE_FORMAT(end_date, '%Y-%m')
)
SELECT 
    a.month,
    IFNULL(c.canceled_in_month, 0) AS canceled_in_month,
    a.active_at_start,
    ROUND((IFNULL(c.canceled_in_month, 0) / a.active_at_start) * 100, 2) AS churn_rate
FROM active_start_month a
LEFT JOIN canceled_end_month c ON a.month = c.month
ORDER BY a.month;

-- Churn rate anual
WITH active_start_year AS (
    -- Calculamos el número de suscripciones activas al inicio de cada año
    SELECT 
        YEAR(start_date) AS year,
        COUNT(user_id) AS active_at_start
    FROM subscriptions
    WHERE status = 'active'
    GROUP BY YEAR(start_date)
),
canceled_end_year AS (
    -- Calculamos el número de suscripciones canceladas en cada año
    SELECT 
        YEAR(end_date) AS year,
        COUNT(user_id) AS canceled_in_year
    FROM subscriptions
    WHERE status = 'canceled'
    GROUP BY YEAR(end_date)
)
SELECT 
    a.year,
    IFNULL(c.canceled_in_year, 0) AS canceled_in_year,
    a.active_at_start,
    ROUND((IFNULL(c.canceled_in_year, 0) / a.active_at_start) * 100, 2) AS churn_rate
FROM active_start_year a
LEFT JOIN canceled_end_year c ON a.year = c.year
ORDER BY a.year;

-- 6. Ingresos por tipo de suscripción (mensual, anual).

WITH payments_detailed AS (
	SELECT subscription_type,
	CASE
		WHEN subscription_type = 'monthly' THEN 9.9
        WHEN subscription_type = 'annual' THEN 99.90
	END AS 'amount'
    FROM subscriptions)
    SELECT subscription_type AS 'Subscription Type', 
    SUM(amount) AS 'Subscription Revenue'
    FROM payments_detailed
    GROUP BY 1;

-- 7. Número de inscripciones por categoría de curso.

SELECT
    c.category,
    COUNT(e.enrollment_id) AS total_enrollments
    FROM courses c
    JOIN enrollments e
		ON c.course_id = e.course_id
	GROUP BY 1
    ORDER BY 2 DESC;

-- 8. Usuarios más activos (con más cursos finalizados).

WITH most_active_users AS (
	SELECT CONCAT(first_name, ' ', last_name) AS full_name, completion_status
	FROM users
	JOIN enrollments
		ON users.user_id = enrollments.user_id)
SELECT full_name, 
SUM(CASE WHEN completion_status = 'completed' THEN 1 ELSE 0 END) AS completed_courses
FROM most_active_users
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- 9. Usuarios más activos (con cuatro cursos finalizados) y cuales son estos cursos.

WITH most_active_users AS (
    SELECT 
        users.user_id, 
        CONCAT(users.first_name, ' ', users.last_name) AS full_name,
        enrollments.course_id,
        enrollments.completion_status
    FROM users
    JOIN enrollments ON users.user_id = enrollments.user_id
    WHERE enrollments.completion_status = 'completed'
),
top_active_users AS (
    SELECT 
        full_name,
        COUNT(course_id) AS completed_courses
    FROM most_active_users
    GROUP BY full_name
    HAVING COUNT(course_id) = 4
    ORDER BY completed_courses DESC
)
SELECT 
    t.full_name, 
    c.course_title
FROM top_active_users t
JOIN most_active_users m ON t.full_name = m.full_name
JOIN courses c ON m.course_id = c.course_id
ORDER BY t.full_name, c.course_title;