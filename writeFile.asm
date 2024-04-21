.data
    fout: .asciiz "Assignment\\history.txt"
    .macro writeToFile(%str, %len)
        .data
            string: .asciiz %str
        .text 
            addi $sp, $sp, -12
            sw $a0, 0($sp)
            sw $a1, 4($sp)
            sw $a2, 8($sp) 
            
            # Write to file just opened
            li   $v0, 15       # syscall 15: Write to file
            move $a0, $s6      # File descriptor 
            la   $a1, string   # Address of buffer from which to write
            li   $a2, %len     # Hardcoded buffer length
            syscall            # Write to file
            
            lw $a2, 8($sp)
            lw $a1, 4($sp)
            lw $a0, 0($sp)
            addi $sp, $sp, 12
    .end_macro    
	
    .macro writeCordinateToFile(%str, %len)
        .text 
            addi $sp, $sp, -12
            sw $a0, 0($sp)
            sw $a1, 4($sp)
            sw $a2, 8($sp) 
            
            # Write to file just opened
            li   $v0, 15       # syscall 15: Write to file
            move $a0, $s6      # File descriptor 
            move  $a1, %str    # Address of buffer from which to write
            li   $a2, %len     # Hardcoded buffer length
            syscall            # Write to file
            
            lw $a2, 8($sp)
            lw $a1, 4($sp)
            lw $a0, 0($sp)
            addi $sp, $sp, 12
    .end_macro
.text
main: 
 	   # Close the file if it's already opened
            li   $v0, 16       # syscall 16: Close file
            move $a0, $s6      # File descriptor to close
            syscall            # Close file syscall

            # Open (for writing) a file that does not exist
            li   $v0, 13       # syscall 13: Open file
            la   $a0, fout     # Output file name
            li   $a1, 1        # Open for writing (flags are 0: read, 1: write)
            li   $a2, 0        # Mode is ignored
            syscall            # Open a file (file descriptor returned in $v0)
            move $s6, $v0      # Save the file descriptor 
    
   la $s1, fout 
    writeCordinateToFile($s1, 22)
    writeToFile("Hello Khoa!\n", 12)

    # Close the file 
    li   $v0, 16       # syscall 16: Close file
    move $a0, $s6      # File descriptor to close
    syscall            # Close file syscall

    li $v0, 10
    syscall 
