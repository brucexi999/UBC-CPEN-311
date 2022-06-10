/* NOTE: this file must be self-contained */

/*
 *  Transforms the pixel (x_in,y_in) using the matrix specified by m.
 *
 *  Pixel coordinates are integers, but the entries of m are Q16 fixed-point numbers.
 *
 *  If the matrix M is defined like this:
 *  
 *      M00 M01 M02
 *      M10 M11 M12
 *      M20 M21 M22
 *
 *  then m[0] is M00, m[1] is M01, m[3] is M10, and so on. The computation is
 *
 *      x_out       M00 M01 M02       x_in
 *      y_out   =   M10 M11 M12   x   y_in
 *      ?           M20 M21 M22       1
 *
 *  and the output pixel will be (*x_out,*y_out).
 */
#define x_out_cor (unsigned *) 0x0001000
#define y_out_cor (unsigned *) 0x0001010
//#define m (int *) 0x0001520

inline void pixel_xform(unsigned x_in, unsigned y_in,
                        unsigned x_out, unsigned y_out, /*Call by reference*/
                        int m[]) {
    x_out = (hw_mult(m[0], x_in) + hw_mult(m[1], y_in) + hw_mult (m[2], 1)) >> 16; 
	y_out = (hw_mult(m[3], x_in) + hw_mult(m[4], y_in) + hw_mult (m[5], 1)) >> 16;
}

extern inline void pixel_xform (unsigned, unsigned, unsigned, unsigned, int []);

int main (){
	int m[] = {46334, 46334, -1245184, -46334, 46334, 4856218};
	unsigned x_out;
	unsigned y_out; 
	pixel_xform (83, 1, x_out, y_out, m);
	*x_out_cor = x_out; 
	*y_out_cor = y_out; 
	return 0; 
};

/*Multiply the matrix with the input coordinate vector to get the translated + rotated + translated back 
coordinate vector. The Q16.16 is taken care by the right shift operation. */

#define mult_N 0x00 //define custom instruction address
#define mult(x,y) __builtin_custom_inii(mult_N, (x), (y)) //define the custom instruction function mult
//#define result (int *) 0x0001000
inline int hw_mult(int x, int y) {
    int product = mult (x, y); 
	return product; 
}

extern inline int hw_mult (int, int); 