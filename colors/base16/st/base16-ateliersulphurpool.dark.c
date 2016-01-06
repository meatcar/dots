

// Base16 Atelier Sulphurpool dark - simple terminal color setup
// Bram de Haan (http://atelierbram.github.io/syntax-highlighting/atelier-schemes/sulphurpool)
static const char *colorname[] = {
	/* Normal colors */
	"#202746", /*  0: Base 00 - Black   */
	"#c94922", /*  1: Base 08 - Red     */
	"#ac9739", /*  2: Base 0B - Green   */
	"#c08b30", /*  3: Base 0A - Yellow  */
	"#3d8fd1", /*  4: Base 0D - Blue    */
	"#6679cc", /*  5: Base 0E - Magenta */
	"#22a2c9", /*  6: Base 0C - Cyan    */
	"#979db4", /*  7: Base 05 - White   */

	/* Bright colors */
	"#6b7394", /*  8: Base 03 - Bright Black */
	"#c94922", /*  9: Base 08 - Red          */
	"#ac9739", /* 10: Base 0B - Green        */
	"#c08b30", /* 11: Base 0A - Yellow       */
	"#3d8fd1", /* 12: Base 0D - Blue         */
	"#6679cc", /* 13: Base 0E - Magenta      */
	"#22a2c9", /* 14: Base 0C - Cyan         */
	"#f5f7ff", /* 15: Base 05 - Bright White */

	/* A few more colors */

	"#c76b29", /* 16: Base 09 */
	"#9c637a", /* 17: Base 0F */
	"#293256", /* 18: Base 01 */
	"#5e6687", /* 19: Base 02 */
	"#898ea4", /* 20: Base 04 */
	"#dfe2f1", /* 21: Base 06 */

	[255] = 0,

	[256] = "#979db4", /* default fg: Base 05 */
	[257] = "#202746", /* default bg: Base 00 */	
};

// Foreground, background and cursor
static unsigned int defaultfg = 256;
static unsigned int defaultbg = 257;
static unsigned int defaultcs = 256;

