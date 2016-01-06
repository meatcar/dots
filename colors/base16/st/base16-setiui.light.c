

// Base16 Seti UI light - simple terminal color setup
// 
static const char *colorname[] = {
	/* Normal colors */
	"#151718", /*  0: Base 00 - Black   */
	"#Cd3f45", /*  1: Base 08 - Red     */
	"#9fca56", /*  2: Base 0B - Green   */
	"#e6cd69", /*  3: Base 0A - Yellow  */
	"#55b5db", /*  4: Base 0D - Blue    */
	"#a074c4", /*  5: Base 0E - Magenta */
	"#55dbbe", /*  6: Base 0C - Cyan    */
	"#d6d6d6", /*  7: Base 05 - White   */

	/* Bright colors */
	"#41535B", /*  8: Base 03 - Bright Black */
	"#Cd3f45", /*  9: Base 08 - Red          */
	"#9fca56", /* 10: Base 0B - Green        */
	"#e6cd69", /* 11: Base 0A - Yellow       */
	"#55b5db", /* 12: Base 0D - Blue         */
	"#a074c4", /* 13: Base 0E - Magenta      */
	"#55dbbe", /* 14: Base 0C - Cyan         */
	"#ffffff", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#db7b55", /* 16: Base 09 */
	"#8a553f", /* 17: Base 0F */
	"#8ec43d", /* 18: Base 01 */
	"#3B758C", /* 19: Base 02 */
	"#43a5d5", /* 20: Base 04 */
	"#eeeeee", /* 21: Base 06 */

	[255] = 0,

	[256] = "#3B758C", /* default fg: Base 02 */
	[257] = "#ffffff", /* default bg: Base 07 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;


