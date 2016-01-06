

// Base16 Atelier Lakeside dark - simple terminal color setup
// Bram de Haan (http://atelierbram.github.io/syntax-highlighting/atelier-schemes/lakeside/)
static const char *colorname[] = {
	/* Normal colors */
	"#161b1d", /*  0: Base 00 - Black   */
	"#d22d72", /*  1: Base 08 - Red     */
	"#568c3b", /*  2: Base 0B - Green   */
	"#8a8a0f", /*  3: Base 0A - Yellow  */
	"#257fad", /*  4: Base 0D - Blue    */
	"#6b6bb8", /*  5: Base 0E - Magenta */
	"#2d8f6f", /*  6: Base 0C - Cyan    */
	"#7ea2b4", /*  7: Base 05 - White   */

	/* Bright colors */
	"#5a7b8c", /*  8: Base 03 - Bright Black */
	"#d22d72", /*  9: Base 08 - Red          */
	"#568c3b", /* 10: Base 0B - Green        */
	"#8a8a0f", /* 11: Base 0A - Yellow       */
	"#257fad", /* 12: Base 0D - Blue         */
	"#6b6bb8", /* 13: Base 0E - Magenta      */
	"#2d8f6f", /* 14: Base 0C - Cyan         */
	"#ebf8ff", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#935c25", /* 16: Base 09 */
	"#b72dd2", /* 17: Base 0F */
	"#1f292e", /* 18: Base 01 */
	"#516d7b", /* 19: Base 02 */
	"#7195a8", /* 20: Base 04 */
	"#c1e4f6", /* 21: Base 06 */

	[255] = 0,

	[256] = "#7ea2b4", /* default fg: Base 05 */
	[257] = "#161b1d", /* default bg: Base 00 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;

