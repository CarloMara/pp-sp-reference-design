
`default_nettype none

module otma_bringup (
    // Clocks
    input           CLK_125M,
    // input           CLK_R_REFCLK5,

    // I2C
    inout           I2C_IDT_SCL,
    inout           I2C_IDT_SDA,

    inout           I2C_QSFP0_SCL,
    inout           I2C_QSFP0_SDA,

    inout           I2C_QSFP1_SCL,
    inout           I2C_QSFP1_SDA,

    // QSFP0
    // input  [3:0]    XCVR_QSFP0_RX,
    // output [3:0]    XCVR_QSFP0_TX,

    // QSFP1
    // input  [3:0]    XCVR_QSFP1_RX,
    // output [3:0]    XCVR_QSFP1_TX,

    // LED
    output [7:0]    LEDS
);


//==============================================================================
// clocks


//==============================================================================
// blinky

logic [27:0] cntr = 0;

always_ff @(posedge CLK_125M) begin: proc_cntr
    cntr <= cntr + 1'd1;
end

assign LEDS[7] = cntr[27];
assign LEDS[6:6] = 'd0;


//==============================================================================
// clock connections

wire [7:0] clk_cntr_meas = {8'd0};

//==============================================================================
// I2C

wire i2c_idt_osc_sda_oe;
wire i2c_idt_osc_scl_oe;

assign I2C_IDT_SDA = i2c_idt_osc_sda_oe ? 1'b0 : 1'bz;
assign I2C_IDT_SCL = i2c_idt_osc_scl_oe ? 1'b0 : 1'bz;

wire i2c_qsfp_0_sda_oe;
wire i2c_qsfp_0_scl_oe;

assign I2C_QSFP0_SDA = i2c_qsfp_0_sda_oe ? 1'b0 : 1'bz;
assign I2C_QSFP0_SCL = i2c_qsfp_0_scl_oe ? 1'b0 : 1'bz;

wire i2c_qsfp_1_sda_oe;
wire i2c_qsfp_1_scl_oe;

assign I2C_QSFP1_SDA = i2c_qsfp_1_sda_oe ? 1'b0 : 1'bz;
assign I2C_QSFP1_SCL = i2c_qsfp_1_scl_oe ? 1'b0 : 1'bz;



//==============================================================================
// qsys

system inst_system (
    .clk_clk                ( CLK_125M                  ),
    .clk_125_clk            ( CLK_125M                  ),
    .clk_cntr_meas          ( clk_cntr_meas             ),
    .clk_cntr_led_dbg       ( LEDS[2]                   ),
    .i2c_idt_osc_sda_in     ( I2C_IDT_SDA               ),
    .i2c_idt_osc_scl_in     ( I2C_IDT_SCL               ),
    .i2c_idt_osc_sda_oe     ( i2c_idt_osc_sda_oe        ),
    .i2c_idt_osc_scl_oe     ( i2c_idt_osc_scl_oe        ),
    .i2c_qsfp_0_sda_in      ( I2C_QSFP0_SDA             ),
    .i2c_qsfp_0_scl_in      ( I2C_QSFP0_SCL             ),
    .i2c_qsfp_0_sda_oe      ( i2c_qsfp_0_sda_oe         ),
    .i2c_qsfp_0_scl_oe      ( i2c_qsfp_0_scl_oe         ),
    .i2c_qsfp_1_sda_in      ( I2C_QSFP1_SDA             ),
    .i2c_qsfp_1_scl_in      ( I2C_QSFP1_SCL             ),
    .i2c_qsfp_1_sda_oe      ( i2c_qsfp_1_sda_oe         ),
    .i2c_qsfp_1_scl_oe      ( i2c_qsfp_1_scl_oe         ),
    .led_dbg_export         ( LEDS[1:0]                 ),
    .reset_reset_n          ( 1'b1                      )
);

endmodule

`default_nettype wire

        // .clk_clk            (<connected-to-clk_clk>),            //         clk.clk
        // .clk_125_clk        (<connected-to-clk_125_clk>),        //     clk_125.clk
        // .clk_cntr_meas      (<connected-to-clk_cntr_meas>),      //    clk_cntr.meas
        // .clk_cntr_led_dbg   (<connected-to-clk_cntr_led_dbg>),   //            .led_dbg
        // .i2c_idt_osc_sda_in (<connected-to-i2c_idt_osc_sda_in>), // i2c_idt_osc.sda_in
        // .i2c_idt_osc_scl_in (<connected-to-i2c_idt_osc_scl_in>), //            .scl_in
        // .i2c_idt_osc_sda_oe (<connected-to-i2c_idt_osc_sda_oe>), //            .sda_oe
        // .i2c_idt_osc_scl_oe (<connected-to-i2c_idt_osc_scl_oe>), //            .scl_oe
        // .i2c_qsfp_0_sda_in  (<connected-to-i2c_qsfp_0_sda_in>),  //  i2c_qsfp_0.sda_in
        // .i2c_qsfp_0_scl_in  (<connected-to-i2c_qsfp_0_scl_in>),  //            .scl_in
        // .i2c_qsfp_0_sda_oe  (<connected-to-i2c_qsfp_0_sda_oe>),  //            .sda_oe
        // .i2c_qsfp_0_scl_oe  (<connected-to-i2c_qsfp_0_scl_oe>),  //            .scl_oe
        // .i2c_qsfp_1_sda_in  (<connected-to-i2c_qsfp_1_sda_in>),  //  i2c_qsfp_1.sda_in
        // .i2c_qsfp_1_scl_in  (<connected-to-i2c_qsfp_1_scl_in>),  //            .scl_in
        // .i2c_qsfp_1_sda_oe  (<connected-to-i2c_qsfp_1_sda_oe>),  //            .sda_oe
        // .i2c_qsfp_1_scl_oe  (<connected-to-i2c_qsfp_1_scl_oe>),  //            .scl_oe
        // .led_dbg_export     (<connected-to-led_dbg_export>),     //     led_dbg.export
        // .reset_reset_n   