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
