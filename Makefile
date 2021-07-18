spark-submit:
	sbt assembly
	spark-submit --class $(CLASS) --master local[4] target/scala-2.11/app.jar
