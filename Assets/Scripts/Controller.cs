using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Controller : MonoBehaviour {

    public Material selectionMat;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        transform.Translate(Input.GetAxis("Horizontal") * 50 * Time.deltaTime, 0.0f,
                            Input.GetAxis("Vertical") * 50 * Time.deltaTime);
        selectionMat.SetVector("_Center", transform.position);
    }
}
