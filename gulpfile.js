const gulp        = require("gulp");
const spritesmith = require("gulp.spritesmith");
const merge       = require("merge-stream");
const path        = require("path");

const IMAGES_DIR           = path.join(__dirname, "src", "img");
const GENERATED_IMAGES_DIR = path.join(IMAGES_DIR, "generated");
const CSS_DIR              = path.join(__dirname, "src", "css");
const GENERATED_CSS_DIR    = path.join(CSS_DIR, "generated");

const ITEMS = ["icons"];

gulp.task("sprites", () => merge(
  ITEMS.map((item) => {
    const images = path.join(IMAGES_DIR, item, "*.*");

    const data = gulp.src(images).pipe(spritesmith({
      imgName: item + ".png",
      cssName: item + ".scss",
      cssVarMap: (sprite) => {
        sprite.name = "sprite-" + sprite.name;
      },
    }));

    return merge(
      data.img.pipe(gulp.dest(GENERATED_IMAGES_DIR)),
      data.css.pipe(gulp.dest(GENERATED_CSS_DIR))
    );
  })
));
