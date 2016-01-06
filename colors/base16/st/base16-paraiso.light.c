

// Base16 Paraiso light - simple terminal color setup
// Jan T. Sott
static const char *colorname[] = {
	/* Normal colors */
	"#2f1e2e", /*  0: Base 00 - Black   */
	"#ef6155", /*  1: Base 08 - Red     */
	"#48b685", /*  2: Base 0B - Green   */
	"#fec418", /*  3: Base 0A - Yellow  */
	"#06b6ef", /*  4: Base 0D - Blue    */
	"#815ba4", /*  5: Base 0E - Magenta */
	"#5bc4bf", /*  6: Base 0C - Cyan    */
	"#a39e9b", /*  7: Base 05 - White   */

	/* Bright colors */
	"#776e71", /*  8: Base 03 - Bright Black */
	"#ef6155", /*  9: Base 08 - Red          */
	"#48b685", /* 10: Base 0B - Green        */
	"#fec418", /* 11: Base 0A - Yellow       */
	"#06b6ef", /* 12: Base 0D - Blue         */
	"#815ba4", /* 13: Base 0E - Magenta      */
	"#5bc4bf", /* 14: Base 0C - Cyan         */
	"#e7e9db", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#f99b15", /* 16: Base 09 */
	"#e96ba8", /* 17: Base 0F */
	"#41323f", /* 18: Base 01 */
	"#4f424c", /* 19: Base 02 */
	"#8d8687", /* 20: Base 04 */
	"#b9b6b0", /* 21: Base 06 */

	[255] = 0,

	[256] = "#4f424c", /* default fg: Base 02 */
	[257] = "#e7e9db", /* default bg: Base 07 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;


