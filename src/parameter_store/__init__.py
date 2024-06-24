
import boto3

# Crear una sesión de boto3 y un cliente de SSM
session = boto3.Session(region_name='us-west-2')  # Cambia la región según sea necesario
ssm_client = session.client('ssm')

def get_parameter(parameter_name, is_secure):
    """
    Obtiene un parámetro del Parameter Store.
    :param name: El nombre del parámetro
    :return: El valor del parámetro
    """
    response = ssm_client.get_parameter(
        Name=parameter_name,
        WithDecryption=is_secure
    )
    return response['Parameter']['Value']