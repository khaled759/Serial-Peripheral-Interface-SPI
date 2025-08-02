if {[file exists work]} {
    vdel -lib work -all
}
vlib work

# Compile VHDL files
vlog src/RAM.v
vlog src/SPI_slave.v
vlog src/SPI_wrapper.v
vlog tb/SPI_tb.sv

# Simulate the testbench
vsim work.SPI_tb

view wave
add wave -position insertpoint sim:/SPI_tb/*

run -all
wave zoom full