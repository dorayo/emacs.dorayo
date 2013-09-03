<?xml version="1.0" encoding="UTF-8"?>

<project name="" default="dist">

  <property file="build.properties"/>

  <path id="project.class.path">
    <fileset dir="${lib}">
      <include name="*.jar"/>
    </fileset>
  </path>

  <!-- ====================================================== -->
  <!-- init                                                   -->
  <!-- ====================================================== -->
  <target name="init" description="initialize the project environment">
    <mkdir dir="${build}"/>
    <mkdir dir="${build.classes}"/>
  </target>

  <!-- ====================================================== -->
  <!-- init test                                              -->
  <!-- ====================================================== -->
  <target name="init-test" description="initialize the test environment">
    <mkdir dir="${build.test.classes}"/>
    <mkdir dir="${reports}"/>
  </target>

  <!-- ====================================================== -->
  <!-- init dist                                              -->
  <!-- ====================================================== -->
  <target name="init-dist">
    <mkdir dir="${dist}"/>
    <mkdir dir="${build.unjar}"/>
  </target>

  <!-- ====================================================== -->
  <!-- Compile the Java files with debug option               -->
  <!-- ====================================================== -->
  <target name="compile" depends="init">
    <javac debug="true" srcdir="${java.src}; ${build.src}" destdir="${build.classes}">
      <classpath refid="project.class.path"/>
      <compilerarg value="-Xlint"/>
      <compilerarg value="-Xlint:-path"/>
    </javac>
  </target>

  <!-- ====================================================== -->
  <!-- Compile the Java files                                 -->
  <!-- ====================================================== -->
  <target name="compileo" depends="init">
    <javac debug="true" srcdir="${src}; ${build.src}" destdir="${build.classes}">
      <classpath refid="project.class.path"/>
      <compilerarg value="-Xlint"/>
      <compilerarg value="-Xlint:-path"/>
    </javac>
  </target>

  <!-- ====================================================== -->
  <!-- Clean and Compile the Java files                       -->
  <!-- ====================================================== -->
  <target name="c" depends="clean, dist"/>
  <target name="co" depends="clean, disto"/>

  <!-- ====================================================== -->
  <!-- Compile test                                           -->
  <!-- ====================================================== -->
  <target name="compile-test" depends="compile, init-test">
    <javac debug="true" srcdir="${test}" destdir="${build.test.classes}">
      <classpath refid="project.class.path"/>
      <classpath path="${build.classes}"/>
    </javac>
  </target>

  <!-- ====================================================== -->
  <!-- Run the Java Application                               -->
  <!-- ====================================================== -->
  <target name="run" depends="compile">
    <java classname="com.comodo.se.main.DDMain" fork="true">
      <classpath refid="project.class.path"/>
      <classpath path="${build.classes}"/>
    </java>
  </target>
	
  <!-- ====================================================== -->
  <!-- Run Junit Tests                                        -->
  <!-- ====================================================== -->
  <target name="test" depends="compile-test">
    <junit printsummary="on" showoutput="true">
      <classpath path="${build.test.classes}"/>
      <classpath path="${build.classes}"/>
      <formatter type="plain"/>
      <classpath refid="project.class.path"/>
      <formatter type="xml"/>
      <batchtest todir="${reports}">
        <fileset dir="${test}" includes="**/Test*.java"/>
      </batchtest>
    </junit>
  </target>

  <!-- ====================================================== -->
  <!-- Generate Junit Tests Report                            -->
  <!-- ====================================================== -->
  <target name="report" depends="test">
    <mkdir dir="${reports.html}"/>
    <junitreport todir="${reports}">
      <fileset dir="${reports}">
        <include name="TEST-*.xml"/>
      </fileset>
      <report format="frames" todir="${reports.html}"/>
    </junitreport>
  </target>

  <!-- ====================================================== -->
  <!-- jar                                                    -->
  <!-- ====================================================== -->
  <target name="jar" depends="init-dist">
    <jar jarfile="${dist}/${final.name}.jar">
      <fileset dir="${build.classes}">
        <include name="**"/>
      </fileset>
    </jar>
  </target>
  
  <!-- ====================================================== -->
  <!-- job                                                    -->
  <!-- ====================================================== -->
  <target name="job" depends="init-dist">
    <unjar dest="${build.unjar}">
      <fileset dir="${lib}">
        <include name="*.jar"/>
        <exclude name="junit*.jar"/>
      </fileset>
    </unjar>

    <jar jarfile="${dist}/${final.name}.job">
      <fileset dir="${build.classes}">
        <include name="**"/>
      </fileset>
      <fileset dir="${build.unjar}">
        <include name="**"/>
      </fileset>
      <fileset dir="${resource}">
      </fileset>
      <manifest>
        <attribute name="Main-Class" value="com.comodo.se..main.DDMain"/>
      </manifest>
    </jar>
  </target>

  <!-- ====================================================== -->
  <!-- distribution                                           -->
  <!-- ====================================================== -->
  <target name="dist" depends="compile, commondist"/>
  <target name="disto" depends="compileo, commondist"/>

  <!-- ====================================================== -->
  <!-- common distribution                                    -->
  <!-- ====================================================== -->
  <target name="commondist" depends="jar">
    <copy todir="${dist}">
      <fileset dir="${resource}">
      </fileset>
    </copy>
  </target>

  <!-- ====================================================== -->
  <!-- clean                                                  -->
  <!-- ====================================================== -->
  <target name="clean">
    <delete dir="${build}"/>
    <delete dir="${dist}"/>
    <delete dir="${reports}"/>
  </target>

</project>
