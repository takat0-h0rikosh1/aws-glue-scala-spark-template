import Dependencies._

ThisBuild / scalaVersion     := "2.11.12"

lazy val root = (project in file("."))
  .settings(
    name := "aws-glue-scala-spark-template",
    scalaVersion := "2.11.12",
    assembly / assemblyJarName := "app.jar",
    assembly / assemblyOption := (assembly / assemblyOption).value.copy(cacheOutput = false),
    assembly / assemblyMergeStrategy := {
      case PathList("META-INF", xs @ _*) => MergeStrategy.discard
      case x                             => MergeStrategy.first
    },
    assembly / assemblyShadeRules := Seq(
      ShadeRule.rename("org.apache.http.**" -> "org.apache.httpShaded").inAll
    ),
    resolvers ++= Seq(
      "aws-glue-etl-artifacts" at "https://aws-glue-etl-artifacts.s3.amazonaws.com/release/"
    ),
    libraryDependencies ++= Seq(
      "com.amazonaws"          % "AWSGlueETL" % "1.0.0"   % "provided",
      "software.amazon.awssdk" % "glue"       % "2.16.84" % "provided",
      "org.apache.spark"      %% "spark-core" % "2.4.7"   % "provided",
      "org.apache.spark"      %% "spark-sql"  % "2.4.8"   % "provided"
    )
  )

