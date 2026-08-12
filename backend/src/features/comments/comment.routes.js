import { Router } from "express";
import {
  addComment,
  deleteComment,
  getVideoComments,
  updateComment,
} from "./comment.controller.js";
import {
  verifyJWT,
  optionalVerifyJWT,
} from "../../shared/middlewares/auth.middleware.js";

const router = Router();

// Public route to read comments (parses token optionally)
router.route("/:videoId").get(optionalVerifyJWT, getVideoComments);

// Secure routes below
router.use(verifyJWT);

router.route("/:videoId").post(addComment);
router.route("/c/:commentId").delete(deleteComment).patch(updateComment);

export default router;
