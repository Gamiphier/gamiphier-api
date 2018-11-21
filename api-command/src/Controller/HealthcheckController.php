<?php

namespace App\Controller;

use FOS\RestBundle\Controller\FOSRestController;
use Symfony\Component\HttpFoundation\JsonResponse;
use FOS\RestBundle\Controller\Annotations;

class HealthcheckController extends FOSRestController
{
    /**
     * @Annotations\Get(
     *     path="/ping", name="healthcheck"
     * )
     */
    public function getAction()
    {
        return $this->json(['pong']);
    }
}
