module com.bjb.upmfx {
    requires javafx.controls;
    requires javafx.fxml;
	requires com.fazecast.jSerialComm;
	requires org.eclipse.xtext.xbase.lib;
	requires javafx.base;
	requires org.eclipse.xtend.lib;
    requires com.google.guice;
    requires org.apache.logging.log4j;
	requires org.apache.logging.log4j.core;
	requires java.xml;

    opens com.bjb.upmfx to javafx.fxml, com.google.guice;
    opens com.bjb.upmfx.view to com.google.guice;
    opens com.bjb.upmfx.data to com.google.guice;
    opens com.bjb.upmfx.wire to com.google.guice;


    exports com.bjb.upmfx;
}
