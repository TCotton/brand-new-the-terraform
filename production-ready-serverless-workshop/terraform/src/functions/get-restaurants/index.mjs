import { DynamoDB } from '@aws-sdk/client-dynamodb'
import { DynamoDBDocumentClient, ScanCommand } from '@aws-sdk/lib-dynamodb'

const dynamodbClient = new DynamoDB()
const dynamodb = DynamoDBDocumentClient.from(dynamodbClient)

const defaultResults = parseInt(process.env.default_results)
const tableName = process.env.restaurants_table

const getRestaurants = async (count) => {
    console.log(`fetching ${count} restaurants from ${tableName}...`)

    const resp = await dynamodb.send(new ScanCommand({
        TableName: tableName,
        Limit: count,
    }))
    console.log(`found ${resp.Items.length} restaurants`)
    return resp.Items
}

export const handler = async (event, context) => {
    const restaurants = await getRestaurants(defaultResults)
    const response = {
        statusCode: 200,
        body: JSON.stringify(restaurants)
    }

    return response
}
