$SV_ROOT = "C:\Users\123uz\Desktop\tutel\git_repos\system_verilog_dpi\dpi_prj\dpi_prj.sim\sim_1\behav\xsim\xsim.dir\work\xsc"
$XSC_OUTPUT = $SV_ROOT+"\custom_dpi.a"
# $C_CODE = "./c_code/"


function xsc_compile {
  xsc ./c_code/stateful.c -o $XSC_OUTPUT
}