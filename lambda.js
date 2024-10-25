const { Client } = require('pg');

exports.handler = async (event) => {
    // Criando uma nova instância do cliente PostgreSQL
    const client = new Client({
        host: process.env.RDS_HOST,
        user: process.env.RDS_USER,
        password: process.env.RDS_PASSWORD,
        database: process.env.RDS_DB,
        port: process.env.RDS_PORT || 5432, // Porto padrão do PostgreSQL
    });

    try {
        // Conectando ao RDS
        await client.connect();

        // Realizando a consulta
        const res = await client.query('SELECT name FROM users WHERE id = $1', [event.userId]);

        // Verificando se há resultados
        if (res.rows.length > 0) {
            return {
                statusCode: 200,
                body: JSON.stringify({
                    username: res.rows[0].name
                }),
            };
        } else {
            return {
                statusCode: 404,
                body: JSON.stringify({
                    message: 'User not found',
                }),
            };
        }
    } catch (error) {
        console.error('Error executing query', error.stack);
        return {
            statusCode: 500,
            body: JSON.stringify({
                message: 'Internal Server Error',
            }),
        };
    } finally {
        // Fechando a conexão
        await client.end();
    }
};
