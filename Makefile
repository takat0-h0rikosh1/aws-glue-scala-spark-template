spark-submit:
	sbt assembly
	spark-submit --class $(CLASS) --master local[4] target/scala-2.11/app.jar

deploy:
	sbt assembly
	aws s3 cp target/scala-2.11/app.jar s3://$(BUCKET)/app.jar
	aws s3 sync src/main/scala/ s3://$(BUCKET)/

REGION=ap-northeast-1
create-bucket:
	aws s3api create-bucket --bucket $(BUCKET) \
		--region $(REGION) --create-bucket-configuration LocationConstraint=$(REGION)

create-job:
	aws glue create-job \
		--name hello-spark \
		--role $(ROLE_NAME) \
		--glue-version 2.0 \
		--command '{ \
		  "Name": "glueetl", \
		  "ScriptLocation": "s3://$(BUCKET)/HelloSparkApp.scala" \
		}' \
		--region $(REGION) \
		--output json \
		--default-arguments '{ \
		  "--job-language": "scala", \
		  "--class": "HelloSparkApp", \
		  "--extra-jars": "s3://$(BUCKET)/app.jar", \
		  "--Message": "HELLO SCALA SPARK ON GLUE!!!" \
		}' \
		--endpoint https://glue.$(REGION).amazonaws.com

ROLE_NAME=aws-glue-scala-spark-template-role
create-role:
	aws iam create-role \
		--role-name $(ROLE_NAME) \
		--assume-role-policy-document file://glue-trust.json
	aws iam attach-role-policy \
		--role-name $(ROLE_NAME) \
		--policy-arn arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole
