
import boto3


def get_parameter(parameter_path, is_secure):
    """Gets value from parameter Store

    Args:
        parameter_path (string): Path where the value is stored in parameter Store
        is_secure (bool): tru if it is secureString

    Returns:
        str: Value stored
    """
    ssm_client = boto3.client('ssm')
    response = ssm_client.get_parameter(
        Name=parameter_path,
        WithDecryption=is_secure
    )
    return response['Parameter']['Value']