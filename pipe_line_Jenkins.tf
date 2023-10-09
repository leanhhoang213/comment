# Thực hiện chạy ở trên Jenkins
pipeline {
    agent any
    environment {
        NAME_SERVICE="hoangla-ecr"
        ECR_REPO="356705062463.dkr.ecr.us-east-2.amazonaws.com"
        REGION="us-east-2"
        FG_CLUSTER="hoangla-cluster"
        FG_SERVICE="hoangla-ecs"
        FG_TD_FAMILY="hoangla-task-defi"
        FG_TD_FILE="td.json"
        CONTAINER_NAME="hoangla_task_defi"
        CONTAINER_MEM="512"
        CONTAINER_CPU="256"
        CONTAINER_PORT=80
        ROLE_ARN="arn:aws:iam::356705062463:role/hoangla-ecs-role"
        VERSION="v1.2"
        NAME_IMAGE_LOCAL="web-demo"
    }
    stages {
        stage('Build') {
            steps {

                sh 'aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin $ECR_REPO'
                sh 'docker tag $NAME_IMAGE_LOCAL:$VERSION $ECR_REPO/$NAME_SERVICE:$VERSION'
                sh 'docker push $ECR_REPO/$NAME_SERVICE:$VERSION'

                // Remove image
                // sh 'docker rmi ${ECR_REPO}/${NAME_SERVICE}:${VERSION}'
                // sh 'docker rmi ${NAME_SERVICE}:${VERSION}'
                sh 'docker rmi $ECR_REPO/$NAME_SERVICE:$VERSION'
            }
        }
        stage('Deploy') {
            steps {
                sh '''
                cat <<_EOF_ > ${FG_TD_FILE}
{
    "executionRoleArn": "arn:aws:iam::356705062463:role/hoangla-ecs-role",
    "containerDefinitions": [
        {
            "image": "$ECR_REPO/$NAME_SERVICE:$VERSION",
            "name": "$CONTAINER_NAME",
            "portMappings": [
                {
                    "hostPort": $CONTAINER_PORT,
                    "protocol": "tcp",
                    "containerPort": $CONTAINER_PORT
                }
            ],
            "environment": [
                {
                    "name": "ASPNETCORE_ENVIRONMENT",
                    "value": "IDA"
                }
            ]
        }
    ],
    "taskRoleArn": "arn:aws:iam::356705062463:role/hoangla-ecs-role",
    "family": "$FG_TD_FAMILY",
    "requiresCompatibilities": [
        "FARGATE"
    ],
    "networkMode": "awsvpc",
    "cpu": "$CONTAINER_CPU",
    "memory": "$CONTAINER_MEM"
}
_EOF_
'''
            }
        }
        stage('Update ECS Task definition') {
            when {
                expression {
                    currentBuild.result == null || currentBuild.result == 'SUCCESS' 
                }
            }
            steps {
                sh 'aws ecs register-task-definition --family ${FG_TD_FAMILY} --region ${REGION} --cli-input-json file://$FG_TD_FILE'
            }
        }
        stage('Update ECS Service') {
            when {
                expression {
                    currentBuild.result == null || currentBuild.result == 'SUCCESS' 
                }
            }
            steps {
                sh 'aws ecs update-service --cluster ${FG_CLUSTER} --service ${FG_SERVICE} --task-definition ${FG_TD_FAMILY} --region ${REGION} --capacity-provider-strategy capacityProvider=FARGATE_SPOT,weight=1,base=0 --force-new-deployment'
            }
            post {
               always {
                   echo 'Wipe all data'
                   deleteDir()
               }
            }
        }
    }
}