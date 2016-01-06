

// Base16 Darktooth dark - simple terminal color setup
// Jason Milkins (https://github.com/jasonm23)
static const char *colorname[] = {
	/* Normal colors */
	"#1D2021", /*  0: Base 00 - Black   */
	"#FB543F", /*  1: Base 08 - Red     */
	"#95C085", /*  2: Base 0B - Green   */
	"#FAC03B", /*  3: Base 0A - Yellow  */
	"#0D6678", /*  4: Base 0D - Blue    */
	"#8F4673", /*  5: Base 0E - Magenta */
	"#8BA59B", /*  6: Base 0C - Cyan    */
	"#A89984", /*  7: Base 05 - White   */

	/* Bright colors */
	"#665C54", /*  8: Base 03 - Bright Black */
	"#FB543F", /*  9: Base 08 - Red          */
	"#95C085", /* 10: Base 0B - Green        */
	"#FAC03B", /* 11: Base 0A - Yellow       */
	"#0D6678", /* 12: Base 0D - Blue         */
	"#8F4673", /* 13: Base 0E - Magenta      */
	"#8BA59B", /* 14: Base 0C - Cyan         */
	"#FDF4C1", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#FE8625", /* 16: Base 09 */
	"#A87322", /* 17: Base 0F */
	"#32302F", /* 18: Base 01 */
	"#504945", /* 19: Base 02 */
	"#928374", /* 20: Base 04 */
	"#D5C4A1", /* 21: Base 06 */

	[255] = 0,

	[256] = "#A89984", /* default fg: Base 05 */
	[257] = "#1D2021", /* default bg: Base 00 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;

