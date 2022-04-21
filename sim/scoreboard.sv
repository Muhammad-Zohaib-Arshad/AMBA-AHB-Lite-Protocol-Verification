`ifndef include_n
`include "burst.sv"
`endif
class scoreboard;
mailbox#(burst) mon2score;
burst pkt;
int burst_count = 0;
int error_count = 0;
logic [31:0] mem[int] = '{default:0};
 
function new (mailbox#(burst) mon2score);
	this.mon2score = mon2score;
endfunction

task run();
forever begin
mon2score.get(pkt);

//////////////////////Write Operation///////////////////
if(pkt.HWRITE)
begin
mem[pkt.HADDR] = pkt.HWDATA;	
burst_count++;	
end
/////////////////////Read Operation//////////////////////
else if(mem[pkt.HADDR] == pkt.HRDATA) 
begin
$display ("************** DATA DOESN'T MATCH, TEST FAILED *************");
burst_count++;
end
else 
begin
$display ("**************DATA HAS MATCHED, TEST PASSED *************");
error_count++;
end
end

endtask
endclass