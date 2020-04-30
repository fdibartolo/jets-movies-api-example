# local: dynamodb-local # port 8000
# admin: env AWS_ACCESS_KEY_ID=$DYNAMODB_ADMIN_AWS_ACCESS_KEY_ID PORT=8001 dynamodb-admin # port 8001

web: jets server # port 8888
dynamodb: cd db//dynamodb_local_latest && java -Djava.library.path=./DynamoDBLocal_lib -jar DynamoDBLocal.jar -sharedDb
