import json
import boto3
from decimal import Decimal

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('visitor-counter')

def lambda_handler(event, context):
    try:
        key = {'pk': 'visitor_Count'}
        response = table.get_item(Key=key)
        if 'Item' not in response:
            table.put_item(Item={'pk': 'visitor_Count', 'count': 0})

        update_response = table.update_item(
            Key=key,
            UpdateExpression='ADD #c :inc',
            ExpressionAttributeNames={'#c': 'count'},
            ExpressionAttributeValues={':inc': 1},
            ReturnValues='UPDATED_NEW'
        )

        updated_count = int(update_response['Attributes']['count'])

        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': 'https://staging.eivistamos.co.uk'
            },
            'body': json.dumps({'count': updated_count})
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'headers': {'Content-Type': 'application/json'},
            'body': json.dumps({'error': str(e)})
        }
