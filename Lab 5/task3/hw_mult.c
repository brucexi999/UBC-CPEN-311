
#define mult_N 0x00 //define custom instruction address
#define mult(x,y) __builtin_custom_inii(mult_N, (x), (y)) //define the custom instruction function mult
//#define result (int *) 0x0001000
inline int hw_mult(int x, int y) {
    int product = mult (x, y); 
	return product; 
}

//extern inline int hw_mult (int, int); 

/*int main () {
	*result = hw_mult(2,3);
	return 0;
}*/
