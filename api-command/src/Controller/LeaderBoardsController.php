<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Routing\Annotation\Route;

class LeaderBoardsController extends AbstractController
{
    /**
     * @Route("/leader/boards", name="leader_boards")
     */
    public function index()
    {
        return $this->json([
            'message' => 'Welcome to your new controller!',
            'path' => 'src/Controller/LeaderBoardsController.php',
        ]);
    }
}
