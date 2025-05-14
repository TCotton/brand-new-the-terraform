import fs from 'fs'

const html = fs.readFileSync('static/index.html', 'utf-8')

export const handler = async (event, context) => {
    const response = {
        statusCode: 200,
        headers: {
            'Content-Type': 'text/html; charset=UTF-8'
        },
        body: html
    }

    return response
}
