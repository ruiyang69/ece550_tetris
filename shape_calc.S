
wait_for_change:
bne $0, $2, check_shape_6
j wait_for_change


#	registers[3] = 32'd6;
#	registers[4] = 32'd10;
#	registers[5] = 32'd12;
#	registers[6] = 32'd14;


check_shape_6:
sub $7, $1, $3
bne $7, $0, check_shape_10
addi $1, $0, 3
j wait_for_change

check_shape_10:
sub $7, $1, $4
bne $7, $0, check_shape_12
addi $1, $0, 7
j wait_for_change

check_shape_12:
sub $7, $1, $5
bne $7, $0, check_shape_14
addi $1, $0, 11
j wait_for_change

check_shape_14:
sub $7, $1, $6
bne $7, $1, add_one
addi $1, $0, 13
j wait_for_change

add_one:
addi $1, $1, 1
j wait_for_change

