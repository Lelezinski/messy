#include "config.h"
#include <systemc-ams.h>

SCA_TDF_MODULE(load_converter)
{
    //Input Port
    sca_tdf::sca_in <double> current_in;
    sca_tdf::sca_in <double> voltage_in;
    //Output Port
    sca_tdf::sca_out <double> current_out;

    SCA_CTOR(load_converter):
        current_in("Current_from_power_instance"),
        voltage_in("Voltage_from_power_instance"),
        current_out("Current_to_power_bus")
    {}

    void set_attributes();
    void initialize();
    void processing();

    void set_efficency(double k);

    load_converter(){}
    
    private:
    double efficency_factor = 1.0;
};