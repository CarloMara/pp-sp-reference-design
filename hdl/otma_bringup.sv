
`default_nettype none

module otma_bringup (
    // Clocks
    input           CLK_125M,
    input           CLK_R_REFCLK5,

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
    input     XCVR_QSFP1_RX,
    output    XCVR_QSFP1_TX,

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
assign LEDS[6:3] = 'd1;



//==============================================================================
// clock connections

wire [7:0] clk_cntr_meas = {6'd0, CLK_125M, CLK_R_REFCLK5};

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
    .clk_5_clk              (CLK_R_REFCLK5),
    .clk_clk                ( CLK_125M                  ),
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
    .reset_reset_n          ( 1'b1                      ),
    .eth_tse_0_serial_connection_rxp             (XCVR_QSFP1_RX),             //     eth_tse_0_serial_connection.rxp
    .eth_tse_0_serial_connection_txp             (XCVR_QSFP1_TX),             //                                .txp
    // .eth_tse_0_status_led_connection_crs         (<connected-to-eth_tse_0_status_led_connection_crs>),         // eth_tse_0_status_led_connection.crs
    // .eth_tse_0_status_led_connection_link        (LEDS[3]),        //                                .link
    // .eth_tse_0_status_led_connection_panel_link  (<connected-to-eth_tse_0_status_led_connection_panel_link>),  //                                .panel_link
    // .eth_tse_0_status_led_connection_col         (<connected-to-eth_tse_0_status_led_connection_col>),         //                                .col
    // .eth_tse_0_status_led_connection_an          (<connected-to-eth_tse_0_status_led_connection_an>),          //                                .an
    // .eth_tse_0_status_led_connection_char_err    (<connected-to-eth_tse_0_status_led_connection_char_err>),    //                                .char_err
    // .eth_tse_0_status_led_connection_disp_err    (<connected-to-eth_tse_0_status_led_connection_disp_err>),    //                                .disp_err
    // .eth_tse_0_mac_misc_connection_ff_tx_crc_fwd (<connected-to-eth_tse_0_mac_misc_connection_ff_tx_crc_fwd>), //   eth_tse_0_mac_misc_connection.ff_tx_crc_fwd
    // .eth_tse_0_mac_misc_connection_ff_tx_septy   (<connected-to-eth_tse_0_mac_misc_connection_ff_tx_septy>),   //                                .ff_tx_septy
    // .eth_tse_0_mac_misc_connection_tx_ff_uflow   (<connected-to-eth_tse_0_mac_misc_connection_tx_ff_uflow>),   //                                .tx_ff_uflow
    // .eth_tse_0_mac_misc_connection_ff_tx_a_full  (<connected-to-eth_tse_0_mac_misc_connection_ff_tx_a_full>),  //                                .ff_tx_a_full
    // .eth_tse_0_mac_misc_connection_ff_tx_a_empty (<connected-to-eth_tse_0_mac_misc_connection_ff_tx_a_empty>), //                                .ff_tx_a_empty
    // .eth_tse_0_mac_misc_connection_rx_err_stat   (<connected-to-eth_tse_0_mac_misc_connection_rx_err_stat>),   //                                .rx_err_stat
    // .eth_tse_0_mac_misc_connection_rx_frm_type   (<connected-to-eth_tse_0_mac_misc_connection_rx_frm_type>),   //                                .rx_frm_type
    // .eth_tse_0_mac_misc_connection_ff_rx_dsav    (<connected-to-eth_tse_0_mac_misc_connection_ff_rx_dsav>),    //                                .ff_rx_dsav
    // .eth_tse_0_mac_misc_connection_ff_rx_a_full  (<connected-to-eth_tse_0_mac_misc_connection_ff_rx_a_full>),  //                                .ff_rx_a_full
    // .eth_tse_0_mac_misc_connection_ff_rx_a_empty (<connected-to-eth_tse_0_mac_misc_connection_ff_rx_a_empty>)  //                                .ff_rx_a_empty
);

    // system u0 (
    //     .clk_clk                                     (<connected-to-clk_clk>),                                     //                             clk.clk
    //     .clk_cntr_meas                               (<connected-to-clk_cntr_meas>),                               //                        clk_cntr.meas
    //     .clk_cntr_led_dbg                            (<connected-to-clk_cntr_led_dbg>),                            //                                .led_dbg
    //     .eth_tse_0_mac_misc_connection_ff_tx_crc_fwd (<connected-to-eth_tse_0_mac_misc_connection_ff_tx_crc_fwd>), //   eth_tse_0_mac_misc_connection.ff_tx_crc_fwd
    //     .eth_tse_0_mac_misc_connection_ff_tx_septy   (<connected-to-eth_tse_0_mac_misc_connection_ff_tx_septy>),   //                                .ff_tx_septy
    //     .eth_tse_0_mac_misc_connection_tx_ff_uflow   (<connected-to-eth_tse_0_mac_misc_connection_tx_ff_uflow>),   //                                .tx_ff_uflow
    //     .eth_tse_0_mac_misc_connection_ff_tx_a_full  (<connected-to-eth_tse_0_mac_misc_connection_ff_tx_a_full>),  //                                .ff_tx_a_full
    //     .eth_tse_0_mac_misc_connection_ff_tx_a_empty (<connected-to-eth_tse_0_mac_misc_connection_ff_tx_a_empty>), //                                .ff_tx_a_empty
    //     .eth_tse_0_mac_misc_connection_rx_err_stat   (<connected-to-eth_tse_0_mac_misc_connection_rx_err_stat>),   //                                .rx_err_stat
    //     .eth_tse_0_mac_misc_connection_rx_frm_type   (<connected-to-eth_tse_0_mac_misc_connection_rx_frm_type>),   //                                .rx_frm_type
    //     .eth_tse_0_mac_misc_connection_ff_rx_dsav    (<connected-to-eth_tse_0_mac_misc_connection_ff_rx_dsav>),    //                                .ff_rx_dsav
    //     .eth_tse_0_mac_misc_connection_ff_rx_a_full  (<connected-to-eth_tse_0_mac_misc_connection_ff_rx_a_full>),  //                                .ff_rx_a_full
    //     .eth_tse_0_mac_misc_connection_ff_rx_a_empty (<connected-to-eth_tse_0_mac_misc_connection_ff_rx_a_empty>), //                                .ff_rx_a_empty
    //     .eth_tse_0_serial_connection_rxp             (<connected-to-eth_tse_0_serial_connection_rxp>),             //     eth_tse_0_serial_connection.rxp
    //     .eth_tse_0_serial_connection_txp             (<connected-to-eth_tse_0_serial_connection_txp>),             //                                .txp
    //     .eth_tse_0_status_led_connection_crs         (<connected-to-eth_tse_0_status_led_connection_crs>),         // eth_tse_0_status_led_connection.crs
    //     .eth_tse_0_status_led_connection_link        (<connected-to-eth_tse_0_status_led_connection_link>),        //                                .link
    //     .eth_tse_0_status_led_connection_panel_link  (<connected-to-eth_tse_0_status_led_connection_panel_link>),  //                                .panel_link
    //     .eth_tse_0_status_led_connection_col         (<connected-to-eth_tse_0_status_led_connection_col>),         //                                .col
    //     .eth_tse_0_status_led_connection_an          (<connected-to-eth_tse_0_status_led_connection_an>),          //                                .an
    //     .eth_tse_0_status_led_connection_char_err    (<connected-to-eth_tse_0_status_led_connection_char_err>),    //                                .char_err
    //     .eth_tse_0_status_led_connection_disp_err    (<connected-to-eth_tse_0_status_led_connection_disp_err>),    //                                .disp_err
    //     .i2c_idt_osc_sda_in                          (<connected-to-i2c_idt_osc_sda_in>),                          //                     i2c_idt_osc.sda_in
    //     .i2c_idt_osc_scl_in                          (<connected-to-i2c_idt_osc_scl_in>),                          //                                .scl_in
    //     .i2c_idt_osc_sda_oe                          (<connected-to-i2c_idt_osc_sda_oe>),                          //                                .sda_oe
    //     .i2c_idt_osc_scl_oe                          (<connected-to-i2c_idt_osc_scl_oe>),                          //                                .scl_oe
    //     .i2c_qsfp_0_sda_in                           (<connected-to-i2c_qsfp_0_sda_in>),                           //                      i2c_qsfp_0.sda_in
    //     .i2c_qsfp_0_scl_in                           (<connected-to-i2c_qsfp_0_scl_in>),                           //                                .scl_in
    //     .i2c_qsfp_0_sda_oe                           (<connected-to-i2c_qsfp_0_sda_oe>),                           //                                .sda_oe
    //     .i2c_qsfp_0_scl_oe                           (<connected-to-i2c_qsfp_0_scl_oe>),                           //                                .scl_oe
    //     .i2c_qsfp_1_sda_in                           (<connected-to-i2c_qsfp_1_sda_in>),                           //                      i2c_qsfp_1.sda_in
    //     .i2c_qsfp_1_scl_in                           (<connected-to-i2c_qsfp_1_scl_in>),                           //                                .scl_in
    //     .i2c_qsfp_1_sda_oe                           (<connected-to-i2c_qsfp_1_sda_oe>),                           //                                .sda_oe
    //     .i2c_qsfp_1_scl_oe                           (<connected-to-i2c_qsfp_1_scl_oe>),                           //                                .scl_oe
    //     .led_dbg_export                              (<connected-to-led_dbg_export>),                              //                         led_dbg.export
    //     .reset_reset_n                               (<connected-to-reset_reset_n>)                                //                           reset.reset_n
    // );
endmodule

`default_nettype wire
