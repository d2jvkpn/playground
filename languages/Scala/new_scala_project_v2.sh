#! /usr/bin/env bash
set -eu -o pipefail

project=$1
wd=$PWD

mkdir $project
cd $project
mkdir -p project src/main/scala src/test/scala
mkdir -p project src/main/scala/x/y
# mkdir lib src/main/resources


cat > build.sbt << EOF
name := "helloWorld"
version := "0.1"
scalaVersion := "2.12.12"

libraryDependencies ++= Seq(
)
EOF


cat > src/main/scala/helloWorld.scala << EOF
import x.y.Obj

object HelloWorld extends App {
	println("Hello, world!")

	Obj.echo()
}
EOF

cat > src/main/scala/x/y/Obj.scala << EOF
package x.y

object Obj {
	def echo(): Unit = {
		println("echo ~~~")
	}
}
EOF


cat > project/build.properties << EOF
sbt.version = 1.4.1
EOF

# sbt compile && sb run

cd $wd

exit

scalac src/main/scala/helloworld.scala -d HelloWorld.jar
scala HelloWorld.jar

## or

scala target/scala-*/*.jar
