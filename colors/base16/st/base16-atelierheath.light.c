

// Base16 Atelier Heath light - simple terminal color setup
// Bram de Haan (http://atelierbram.github.io/syntax-highlighting/atelier-schemes/heath)
static const char *colorname[] = {
	/* Normal colors */
	"#1b181b", /*  0: Base 00 - Black   */
	"#ca402b", /*  1: Base 08 - Red     */
	"#918b3b", /*  2: Base 0B - Green   */
	"#bb8a35", /*  3: Base 0A - Yellow  */
	"#516aec", /*  4: Base 0D - Blue    */
	"#7b59c0", /*  5: Base 0E - Magenta */
	"#159393", /*  6: Base 0C - Cyan    */
	"#ab9bab", /*  7: Base 05 - White   */

	/* Bright colors */
	"#776977", /*  8: Base 03 - Bright Black */
	"#ca402b", /*  9: Base 08 - Red          */
	"#918b3b", /* 10: Base 0B - Green        */
	"#bb8a35", /* 11: Base 0A - Yellow       */
	"#516aec", /* 12: Base 0D - Blue         */
	"#7b59c0", /* 13: Base 0E - Magenta      */
	"#159393", /* 14: Base 0C - Cyan         */
	"#f7f3f7", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#a65926", /* 16: Base 09 */
	"#cc33cc", /* 17: Base 0F */
	"#292329", /* 18: Base 01 */
	"#695d69", /* 19: Base 02 */
	"#9e8f9e", /* 20: Base 04 */
	"#d8cad8", /* 21: Base 06 */

	[255] = 0,

	[256] = "#695d69", /* default fg: Base 02 */
	[257] = "#f7f3f7", /* default bg: Base 07 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;


