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
		--role AWSGlueServiceRoleDefault \
		--command '{ \
		  "Name": "gluestreaming", \
		  "ScriptLocation": "s3://$(BUCKET)/HelloSparkApp.scala" \
		}' \
		--region $(REGION) \
		--output json \
		--default-arguments '{ \
		  "--job-language":"scala", \
		  "--class":"HelloSparkApp" \
		}' \
		--endpoint https://glue.$(REGION).amazonaws.com
