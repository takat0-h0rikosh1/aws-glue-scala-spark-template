import com.amazonaws.services.glue.GlueContext
import com.amazonaws.services.glue.util.{GlueArgParser, Job}
import org.apache.spark.SparkContext
import org.apache.spark.sql.SparkSession

import scala.collection.JavaConverters._

object HelloSparkApp {

  def main(sysArgs: Array[String]) {
    val spark: SparkContext      = new SparkContext()
    val glueContext: GlueContext = new GlueContext(spark)

    val args = GlueArgParser.getResolvedOptions(sysArgs, Seq("TempDir", "JOB_NAME", "Message").toArray)
    println(args("Message"))

    Job.init(args("JOB_NAME"), glueContext, args.asJava)

    StdoutPeople.run()

    Job.commit()
  }
}

object StdoutPeople {

  def run(): Unit = {

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

object HelloSparkAppOnLocal {
  def main(args: Array[String]): Unit = StdoutPeople.run()
}
