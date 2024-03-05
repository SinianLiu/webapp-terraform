# webapp

CSYE6225 - webapp
Name: Sinian Liu
NUID:002790887


# Description

HealthZ Application to check the health of Database Server connection and manage users' registeration information. The entire Application has 4 API EndPoints secured with Basic Auth.

1. GET --/v1/users
2. PUT-- /v1/users
3. POST--/v1/users
4. GET--/healthz

# Prerequisites

1.POSTMAN
2.Database - Postgres
3.Node.js

# Build the app locally

1. Create a Postgres Database locally

sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '123456';"
PGPASSWORD=123456 psql -h localhost -U postgres -c "CREATE DATABASE webapp;"

2. Bootstraping the database

Here we use Sequelize, a promise-based Node.js ORM.
Steps:

1. Install Sequelize and its CLI:

```
npm install --save sequelize
npm install --save pg pg-hstore # This is for PostgreSQL
npm install --save-dev sequelize-cli
```

2. Initialize Sequelize:

- npx sequelize-cli init
- Then it will generates 4 directories: config, models, migrations, and seeders
- Define config.json
  {
  "development": {
  "username": "postgres",
  "password": "123456",
  "database": "webapp",
  "host": "localhost",
  "dialect": "postgres"
  }
  }
- Define your user.js files
- npx sequelize-cli migration:generate --name create-user

3. Then create-user.js file was created in the migrations directory.

- Define the up and down methods to create and drop the Users table

4. In server.js file, add code:

```
const Sequelize = require('sequelize');
const UserModel = require('./models/user');

Initialize Sequelize and models:
const sequelize = new Sequelize(
  'webapp',
  'postgres',
  '123456', {
  host: 'localhost',
  dialect: 'postgres'
});

UserModel.init(sequelize);

sequelize.sync({ force: false })
  .then(() => {
    console.log(`Database & tables created!`)
  });
```

5. Run your latest migrations:
   npx sequelize-cli db:migrate

- Check the table

```
psql -h 127.0.0.1 -U postgres -d webapp
check all the tables: \dt
\q
check the specific table: \d "Users";
SELECT * FROM "Users";
```

- Everytime when the table defination changes, need to execute:

```
- npx sequelize-cli migration:generate --name <xxx>
- change the content in the immigration file created
- npx sequelize-cli db:migrate

```

# Github CI workflows:

1. Status Checks workflow
2. Integration Test workflow
3. Packer build image workflow (run after being merged)

# Use Packer to Build the Image

folder: gcp-packer

1. create xxx.pkr.hcl file
   gcp.pkr.hcl

2. Set up Packer GCP plugin

```
packer {
  required_plugins {
    googlecompute = {
      source  = "github.com/hashicorp/googlecompute"
      version = ">= 1.0.0, < 2.0.0"
    }
  }
}
```

Run:
packer init .
or:
packer init gcp.pkr.hcl

3. Config your image build processes

4. packer validate gcp.pkr.hcl
   packer build gcp.pkr.hcl
   packer build -var 'project_id=dev-project-415104' -var 'zone=us-west1-a' gcp.pkr.hcl

5. create service account in the GCP project, then give the credentials to Github so that it could run build process in the github workflow

project id: dev-project-415104

```
$ gcloud iam service-accounts create packer \
  --project dev-project-415104 \
  --description="Packer Service Account" \
  --display-name="Packer Service Account"

- IAM & Admin "Service Accounts" created

<!-- assign roles-->
$ gcloud projects add-iam-policy-binding dev-project-415104 \
    --member=serviceAccount:packer@dev-project-415104.iam.gserviceaccount.com \
    --role=roles/compute.instanceAdmin.v1

$ gcloud projects add-iam-policy-binding dev-project-415104 \
    --member=serviceAccount:packer@dev-project-415104.iam.gserviceaccount.com \
    --role=roles/iam.serviceAccountUser

$ gcloud projects add-iam-policy-binding dev-project-415104 \
    --member=serviceAccount:packer@dev-project-415104.iam.gserviceaccount.com \
    --role=roles/iap.tunnelResourceAccessor


permission -> view access -> continue -> run query
keys -> create json keys -> copy keys to github org repo settings
settings -> secrets and variables -> actions -> new repo secret

Now your github workflow could use packer to build a image in a GCP project,


```

ConditionPathExists=/opt/myapp/app.properties
