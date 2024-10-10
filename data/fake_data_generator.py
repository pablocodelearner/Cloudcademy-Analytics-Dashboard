import pandas as pd
import random
from faker import Faker
from datetime import timedelta, date

# Inicializamos Faker y definimos la fecha de hoy
fake = Faker()
today = date(2024, 9, 30)

# Elige un número de usuarios entre 700 y 900
num_users = random.randint(700, 900)

# Tabla 1: users
user_data = {
    "user_id": range(1, num_users + 1),
    "first_name": [fake.first_name() for _ in range(num_users)],
    "last_name": [fake.last_name() for _ in range(num_users)],
    "email": [fake.email() for _ in range(num_users)],
    "registration_date": [fake.date_between(start_date="-2y", end_date="today") for _ in range(num_users)]
}
df_users = pd.DataFrame(user_data)

# Tabla 2: courses (misma cantidad)
course_data = {
    "course_id": range(1, 31),
    "course_title": [
        "Introduction to Cloud Computing", "Google Cloud for Beginners", "DevOps on AWS", "Cloud Solutions Architecture on AWS", 
        "Advanced Kubernetes", "Kubernetes Intermediate", "Kubernetes for Beginners", "Security in Google Cloud", 
        "Introduction to AWS", "Introduction to Azure", "Azure Solutions Architect Certification", "Google Cloud Digital Leader Training", 
        "Machine Learning Operations with AWS", "Google Cloud Certification: Cloud DevOps Engineer", 
        "Certified Kubernetes Application Developer", "Kubernetes for Absolute Beginners with Labs", "AWS MasterClass: DevOps with CLI", 
        "Microsoft Azure: Zero to Hero Guide", "Serverless Computing on AWS", "Cloud Migration Strategies with Google Cloud", 
        "Introduction to DevOps Practices", "Scaling Applications on Kubernetes", "AWS Lambda Deep Dive", 
        "Automating Infrastructure with Terraform", "Azure DevOps Solutions", "Google Cloud Security Essentials", 
        "AI and ML on AWS", "Building Microservices on Google Cloud", "Introduction to Docker", "Advanced Serverless Architectures"
    ],
    "category": [
        "cloud computing", "google cloud", "aws", "aws", "kubernetes", "kubernetes", "kubernetes", "google cloud", "aws", 
        "azure", "azure", "google cloud", "aws", "google cloud", "kubernetes", "kubernetes", "aws", "azure", "aws", 
        "google cloud", "devops", "kubernetes", "aws", "devops", "azure", "google cloud", "aws", "google cloud", 
        "devops", "aws"
    ],
    "level": [
        "beginner", "beginner", "beginner", "beginner", "advanced", "intermediate", "beginner", "intermediate", "beginner", 
        "beginner", "beginner", "beginner", "advanced", "advanced", "advanced", "beginner", "intermediate", "beginner", 
        "intermediate", "intermediate", "beginner", "advanced", "advanced", "intermediate", "intermediate", "beginner", 
        "intermediate", "advanced", "beginner", "advanced"
    ],
    "duration": [
        90, 40, 36, 48, 40, 16, 13, 40, 40, 40, 40, 36, 48, 28, 21, 40, 36, 40, 24, 30, 32, 25, 22, 20, 18, 12, 26, 34, 16, 28
    ]
}
df_courses = pd.DataFrame(course_data)

# Tabla 3: subscriptions
subscription_data = {
    "subscription_id": range(1, num_users + 1),
    "user_id": [random.randint(1, num_users) for _ in range(num_users)],
    "subscription_type": [random.choice(['monthly', 'annual']) for _ in range(num_users)],
    "start_date": [fake.date_between(start_date="-2y", end_date="today") for _ in range(num_users)]
}

subscription_data['end_date'] = []
subscription_data['status'] = []
for i in range(num_users):
    if subscription_data['subscription_type'][i] == 'monthly':
        end_date = subscription_data['start_date'][i] + timedelta(days=30)
    else:
        end_date = subscription_data['start_date'][i] + timedelta(days=365)
    subscription_data['end_date'].append(end_date)
    subscription_data['status'].append('active' if end_date >= today else 'canceled')
df_subscriptions = pd.DataFrame(subscription_data)

# Tabla 4: payments
payment_data = {
    "payment_id": range(1, num_users + 1),
    "user_id": [random.randint(1, num_users) for _ in range(num_users)],
    "amount": [9.90 if subscription_data['subscription_type'][i] == 'monthly' else 99.90 for i in range(num_users)],
    "payment_date": [fake.date_between(start_date="-2y", end_date="today") for _ in range(num_users)]
}
df_payments = pd.DataFrame(payment_data)

# Tabla 5: enrollments
num_enrollments = random.randint(num_users * 2, num_users * 3)
enrollment_data = {
    "enrollment_id": range(1, num_enrollments + 1),
    "user_id": [random.randint(1, num_users) for _ in range(num_enrollments)],
    "course_id": [random.randint(1, 30) for _ in range(num_enrollments)],
    "enrollment_date": [fake.date_between(start_date="-3y", end_date="today") for _ in range(num_enrollments)],
    "completion_status": ['in_progress' for _ in range(num_enrollments)]
}
df_enrollments = pd.DataFrame(enrollment_data)

# Asignar 'dropped' a aproximadamente el 10% de las filas
num_dropped = int(0.1 * num_enrollments)
dropped_indices = random.sample(range(num_enrollments), num_dropped)
df_enrollments.loc[dropped_indices, 'completion_status'] = 'dropped'

# Asignar 'completed' a inscripciones con fecha en 2022 o antes
df_enrollments.loc[df_enrollments['enrollment_date'] <= date(2022, 12, 31), 'completion_status'] = 'completed'

# Guardar como CSV
csv_path = 'C:/Users/teram/Desktop/Python/SQL Project/Generación de datos ficticios/'

df_users.to_csv(f'{csv_path}users.csv', index=False)
df_courses.to_csv(f'{csv_path}courses.csv', index=False)
df_subscriptions.to_csv(f'{csv_path}subscriptions.csv', index=False)
df_enrollments.to_csv(f'{csv_path}enrollments.csv', index=False)
df_payments.to_csv(f'{csv_path}payments.csv', index=False)
