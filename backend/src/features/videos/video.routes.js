import { Router } from "express";
import {
  deleteVideo,
  getAllVideos,
  getVideoById,
  incrementVideoViews,
  publishAVideo,
  togglePublishStatus,
  updateVideo,
} from "./video.controller.js";
import {
  verifyJWT,
  optionalVerifyJWT,
} from "../../shared/middlewares/auth.middleware.js";
import { upload } from "../../shared/middlewares/multer.middleware.js";

const router = Router();

// Public routes (readable without auth)
router.route("/").get(optionalVerifyJWT, getAllVideos);
router.route("/:videoId").get(optionalVerifyJWT, getVideoById);
router.route("/views/:videoId").patch(optionalVerifyJWT, incrementVideoViews);

// Secure routes (require JWT verification)
router.use(verifyJWT);

router.route("/").post(
  upload.fields([
    {
      name: "videoFile",
      maxCount: 1,
    },
    {
      name: "thumbnail",
      maxCount: 1,
    },
  ]),
  publishAVideo
);

router
  .route("/:videoId")
  .delete(deleteVideo)
  .patch(upload.single("thumbnail"), updateVideo);

router.route("/toggle/publish/:videoId").patch(togglePublishStatus);

export default router;
