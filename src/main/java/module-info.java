module com.bjb.upmfx {
    requires javafx.controls;
    requires javafx.fxml;

    opens com.bjb.upmfx to javafx.fxml;
    exports com.bjb.upmfx;
}
