using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using TMPro;

public class PosibleBarquito : MonoBehaviour
{
	float verticalInput;
	float movementFactor;
	float horizontalInput;
	float steerFactor;
	float clampedSpeed;
	float clampedSteerSpeed;
	public float speed = 1.0f;
	public float steerSpeed = 1.0f;
    public float movementThresold = 10.0f;
	public float minSpeedLimit = 1f;
	public float maxSpeedLimit = 3f;
	public float minSpeedSteerLimit = 2f;
	public float maxSpeedSteerLimit = 3f;


	public enum MovementType
    {
		keyboard,
		controller
    };

	public MovementType movementType;

	void Update()
    {
		if (movementType == MovementType.keyboard)
		{
			verticalInput = Input.GetAxis("Vertical");
			clampedSpeed = Mathf.Clamp(speed, minSpeedLimit, maxSpeedLimit);
			movementFactor = Mathf.Lerp(movementFactor, verticalInput, Time.deltaTime / movementThresold);
			transform.Translate(0.0f, 0.0f, movementFactor * clampedSpeed);

			horizontalInput = Input.GetAxis("Horizontal");
			clampedSteerSpeed = Mathf.Clamp(steerSpeed, minSpeedSteerLimit, maxSpeedSteerLimit);
			steerFactor = Mathf.Lerp(steerFactor, horizontalInput * verticalInput, Time.deltaTime / movementThresold);
			transform.Rotate(0.0f, steerFactor * clampedSteerSpeed, 0.0f);
		}
		else
		{
			if (movementType == MovementType.controller)
            {
				verticalInput = Input.GetAxis("VerticalGamepad");
				clampedSpeed = Mathf.Clamp(speed, minSpeedLimit, maxSpeedLimit);
				movementFactor = Mathf.Lerp(movementFactor, verticalInput, Time.deltaTime / movementThresold);
				transform.Translate(0.0f, 0.0f, movementFactor * clampedSpeed);

				horizontalInput = Input.GetAxis("HorizontalGamepad");
				clampedSteerSpeed = Mathf.Clamp(steerSpeed, minSpeedSteerLimit, maxSpeedSteerLimit);
				steerFactor = Mathf.Lerp(steerFactor, horizontalInput * verticalInput, Time.deltaTime / movementThresold);
				transform.Rotate(0.0f, steerFactor * clampedSteerSpeed, 0.0f);
			}
		}

		//Movement();
		//Steer();
	}

	/*void Movement()
    {
        verticalInput = Input.GetAxis("Vertical");
		clampedSpeed = Mathf.Clamp(speed, minSpeedLimit, maxSpeedLimit);
		movementFactor = Mathf.Lerp(movementFactor, verticalInput, Time.deltaTime / movementThresold);
        transform.Translate(0.0f, 0.0f, movementFactor * clampedSpeed);

	}

	/*void Steer()
	{
		horizontalInput = Input.GetAxis("Horizontal");
		clampedSteerSpeed = Mathf.Clamp(steerSpeed, minSpeedSteerLimit, maxSpeedSteerLimit);
		steerFactor = Mathf.Lerp(steerFactor, horizontalInput * verticalInput, Time.deltaTime / movementThresold);
		transform.Rotate(0.0f, steerFactor * clampedSteerSpeed, 0.0f);

	}*/
}