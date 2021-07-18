import org.apache.spark.sql.SparkSession

object HelloSpark {
  def main(args: Array[String]): Unit = {

    val spark = SparkSession.builder.appName(this.getClass.getName).getOrCreate()
    import spark.implicits._

    val people = Seq(
      ("Spark太郎", "spark-taro@example.com", "2021-01-01", 11),
      ("Spark二郎", "spark-jiro@example.com", "2021-02-02", 12),
      ("Spark三郎", "spark-saburo@example.com", "2021-03-03", 13)
    ).toDF("name", "email", "birthday", "age")

    people.printSchema()
    people.show(3)
  }
}
