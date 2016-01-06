

// Base16 Yesterday Night light - simple terminal color setup
// FroZnShiva (https://github.com/FroZnShiva)
static const char *colorname[] = {
	/* Normal colors */
	"#343d46", /*  0: Base 00 - Black   */
	"#cc6666", /*  1: Base 08 - Red     */
	"#b5bd68", /*  2: Base 0B - Green   */
	"#f0c674", /*  3: Base 0A - Yellow  */
	"#81a2be", /*  4: Base 0D - Blue    */
	"#b294bb", /*  5: Base 0E - Magenta */
	"#8abeb7", /*  6: Base 0C - Cyan    */
	"#dfe1e8", /*  7: Base 05 - White   */

	/* Bright colors */
	"#a7adba", /*  8: Base 03 - Bright Black */
	"#cc6666", /*  9: Base 08 - Red          */
	"#b5bd68", /* 10: Base 0B - Green        */
	"#f0c674", /* 11: Base 0A - Yellow       */
	"#81a2be", /* 12: Base 0D - Blue         */
	"#b294bb", /* 13: Base 0E - Magenta      */
	"#8abeb7", /* 14: Base 0C - Cyan         */
	"#ffffff", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#de935f", /* 16: Base 09 */
	"#a3685a", /* 17: Base 0F */
	"#4f5b66", /* 18: Base 01 */
	"#65737e", /* 19: Base 02 */
	"#c0c5ce", /* 20: Base 04 */
	"#eff1f5", /* 21: Base 06 */

	[255] = 0,

	[256] = "#65737e", /* default fg: Base 02 */
	[257] = "#ffffff", /* default bg: Base 07 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;


