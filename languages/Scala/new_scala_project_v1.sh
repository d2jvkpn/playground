#! /usr/bin/env bash
set -eu -o pipefail

project=$1
wd=$PWD

mkdir $project
cd $project
mkdir -p project src/main/scala src/test/scala
# mkdir lib src/main/resources


cat > build.sbt << EOF
name := "hello_world"
version := "0.1"
scalaVersion := "2.12.10"

libraryDependencies ++= Seq(
)
EOF


cat > src/main/scala/HelloWorld.scala << EOF
object HelloWorld {
	def main(args: Array[String]) {
		println("Hello, world!")
	}
}
EOF


cat > project/build.properties << EOF
sbt.version = 1.4.1
EOF

# sbt compile && sb run

cd $wd

exit

scalac src/main/scala/Helloworld.scala -d HelloWorld.jar
scala HelloWorld.jar

scala target/scala-*/*.jar
