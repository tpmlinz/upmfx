package com.bjb.upmfx;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;

import java.io.IOException;

import org.apache.logging.log4j.Level;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.core.config.Configurator;
import org.apache.logging.log4j.spi.LoggerContext;

import com.google.inject.Guice;
import com.google.inject.Injector;


/**
 * JavaFX App
 */
public class App extends Application {

    private static Scene scene;
    
   

    @Override
    public void start(Stage stage) throws IOException {

        //scene = new Scene(loadFXML("primary"), 640, 480);
        scene = new Scene(loadFXML("mainwin"), 640, 480);
        scene.getStylesheets().add(App.class.getResource("upm3.css").toExternalForm());
        //main/resources/com/bjb/upmfx/upm3.css
        stage.setScene(scene);
        stage.show();
    }

    static void setRoot(String fxml) throws IOException {
        scene.setRoot(loadFXML(fxml));
    }
    
//    static Parent getRoot() {
//    	return scene.getRoot();
//    }

    private static Parent loadFXML(String fxml) throws IOException {
    	Injector injector = Guice.createInjector(new AppModule());    	
        FXMLLoader fxmlLoader = new FXMLLoader(App.class.getResource(fxml + ".fxml"));
        fxmlLoader.setControllerFactory(injector::getInstance);       
        return fxmlLoader.<Parent>load();
    }

    public static void main(String[] args) {
    	
    	//Configurator.setAllLevels(LogManager.getRootLogger().getName(), Level.ALL);    	    	
        launch();
    }
    
}