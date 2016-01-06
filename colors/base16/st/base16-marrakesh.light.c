

// Base16 Marrakesh light - simple terminal color setup
// Alexandre Gavioli (http://github.com/Alexx2/)
static const char *colorname[] = {
	/* Normal colors */
	"#201602", /*  0: Base 00 - Black   */
	"#c35359", /*  1: Base 08 - Red     */
	"#18974e", /*  2: Base 0B - Green   */
	"#a88339", /*  3: Base 0A - Yellow  */
	"#477ca1", /*  4: Base 0D - Blue    */
	"#8868b3", /*  5: Base 0E - Magenta */
	"#75a738", /*  6: Base 0C - Cyan    */
	"#948e48", /*  7: Base 05 - White   */

	/* Bright colors */
	"#6c6823", /*  8: Base 03 - Bright Black */
	"#c35359", /*  9: Base 08 - Red          */
	"#18974e", /* 10: Base 0B - Green        */
	"#a88339", /* 11: Base 0A - Yellow       */
	"#477ca1", /* 12: Base 0D - Blue         */
	"#8868b3", /* 13: Base 0E - Magenta      */
	"#75a738", /* 14: Base 0C - Cyan         */
	"#faf0a5", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#b36144", /* 16: Base 09 */
	"#b3588e", /* 17: Base 0F */
	"#302e00", /* 18: Base 01 */
	"#5f5b17", /* 19: Base 02 */
	"#86813b", /* 20: Base 04 */
	"#ccc37a", /* 21: Base 06 */

	[255] = 0,

	[256] = "#5f5b17", /* default fg: Base 02 */
	[257] = "#faf0a5", /* default bg: Base 07 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;


